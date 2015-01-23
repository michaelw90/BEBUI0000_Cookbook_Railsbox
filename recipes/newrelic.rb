#
# Cookbook Name:: cookbook_railsbox
# Recipe:: newrelic
#

if node['cookbook_railsbox']['newrelic']
  newrelic_licence_key = node['cookbook_railsbox']['newrelic']['license_key']
  if newrelic_licence_key != nil

    Chef::Log.info %(Set newrelic license to node['cookbook_railsbox']['newrelic']['license_key'])
    Chef::Log.info newrelic_licence_key

    node.set['newrelic']['license'] = newrelic_licence_key
    node.set['newrelic']['server_monitoring']['license'] = newrelic_licence_key
    node.set['newrelic']['application_monitoring']['license'] = newrelic_licence_key
    node.set['newrelic']['plugin_monitoring']['license'] = newrelic_licence_key
    node.set['newrelic']['application_monitoring']['app_name'] = node['cookbook_railsbox']['appname']
    #node.set['newrelic']['install_dir'] = '/opt/newrelic'
    include_recipe 'newrelic::repository'
    include_recipe 'newrelic::server_monitor_agent'
  end
end