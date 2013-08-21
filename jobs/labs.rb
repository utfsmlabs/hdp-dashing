require 'open-uri'
settings = YAML.load_file("config.yaml")
pcs = Hash.new

SCHEDULER.every '5s', :first_in => 0 do |job|	
  url = "http://meru/icinga/cgi-bin/status.cgi?hostgroup=lds&hostgroup=lpa&style=overview&scroll=0&hoststatustypes=4&jsonoutput"
  labs = JSON.parse(open(url,:http_basic_authentication=>['icingaadmin',settings["config"]["icinga"]]).read)["status"]["hostgroup_overview"].flat_map{|group| group["members"]}
  labs.map! do |host| {name: host["host_name"]}
  end
  send_event('labs', { labs: labs })
end

