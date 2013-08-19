settings = YAML.load_file("config.yaml")
hash_tareas = Hash.new

SCHEDULER.every '1m', :first_in => 0 do |job|	
  base_url = URI("http//meru/icinga/cgi-bin/status.cgi?hostgroup=lds&hostgroup=lpa&style=overview&scroll=0&hoststatustypes=4&jsonoutput")
  req = Net::HTTP.get(base_url)
  req.basic_auth 'Settings.','Settings.'
  res = Net::HTTP.start(base_url.hostname, base_url.port){|http|
    http.request(req)
  }
  pcs_apagados = JSON.parse(res.body).force_encoding('utf-8'))["status"]["hostgroup_overview"].flat_map{|group| group["members"]}.map{|host| host["host_name"]}

  send_event('icingalabs_list', { pcs: pcs_apagados })
end
