settings = YAML.load_file("config.yaml")
hash_tareas = Hash.new

SCHEDULER.every '10m', :first_in => 0 do |job|
	base_url = "http://code.inf.santiago.usm.cl/projects/primos/issues"
  issue_url = "http://code.inf.santiago.usm.cl/issues"
  code_api = settings["config"]["code_api"]
  json_end = ".json?key="+code_api+"&limit=11"
  incluir_changesets = "&include=changesets,journals"
  tareas = JSON.parse(Net::HTTP.get(URI.parse(base_url+json_end)).force_encoding('utf-8'))['issues']

  tareas.each do |issue|
    sub_url = "/"+issue['id'].to_s
    extras = JSON.parse(Net::HTTP.get(URI.parse(issue_url+sub_url+json_end+incluir_changesets)).force_encoding('utf-8'))['issue']['journals']
    issue['journals'] = extras 
  end
  
  if tareas
    tareas.map! do |tarea|
      if tarea['assigned_to']
        asignado_a = tarea['assigned_to']['name']
      else
        asignado_a = tarea['author']['name']
      end
      { name: tarea['subject'], description: tarea['description'], assigned_to: "Asignado a: #{asignado_a}", done_ratio: "Completado en un #{tarea['done_ratio']}%" }
    end


  end

  send_event('code_list', { tasks: tareas })
end