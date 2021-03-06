# -*- encoding : utf-8 -*-
require 'open-uri'
settings = YAML.load_file("config.yaml")

SCHEDULER.every '60s', :first_in => 0 do |job|	
  url = "http://meru.inf.santiago.usm.cl/icinga/cgi-bin/status.cgi?hostgroup=lds&hostgroup=lpa&style=overview&scroll=0&hoststatustypes=4&jsonoutput"
  labs = JSON.parse(open(url,:http_basic_authentication=>['icingaadmin',settings["config"]["icinga"]]).read)["status"]["hostgroup_overview"].flat_map{|group| group["members"]}
  labs.map! do |host| {name: host["host_name"]}
  end
  send_event('labs', { labs: labs })
end

