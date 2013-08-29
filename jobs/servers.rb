require 'open-uri'
settings = YAML.load_file("config.yaml")

SCHEDULER.every '5m', :first_in => 0 do |job|	
  url = "http://meru/icinga/cgi-bin/status.cgi?hostgroup=linux-servers&hostgroup=databases&style=overview&scroll=0&jsonoutput"
  servers = JSON.parse(open(url,:http_basic_authentication=>['icingaadmin',settings["config"]["icinga"]]).read)["status"]["hostgroup_overview"].flat_map{|group| group["members"]}
  servers.map! do |host| {name: host["host_name"], status: host["host_status"], services_ok: host["services_status_ok"], total_services: host["services_status_critical"].to_i + host["services_status_unknown"].to_i + host["services_status_ok"].to_i + host["services_status_warning"].to_i + host["services_status_critial"].to_i }
  end
  send_event('servers', { servers: servers })
end

