#
# Cookbook Name:: cookbook_railsbox
# Recipe:: rackspace
#

if node['cookbook_railsbox']['rackspace']

  rackspace_username = node['cookbook_railsbox']['rackspace']['username']
  rackspace_api_key = node['cookbook_railsbox']['rackspace']['api_key']
  rackspace_monitoring = node['cookbook_railsbox']['rackspace']['monitoring']
  rackspace_backup = node['cookbook_railsbox']['rackspace']['backup']

  if rackspace_username != '' && rackspace_api_key

    node.set['rackspace']['cloud_credentials']['username'] = rackspace_username
    node.set['rackspace']['cloud_credentials']['api_key'] = rackspace_api_key

    if rackspace_monitoring == true

      # Calculate default values
      # Critical at x4 CPU count
      cpu_critical_threshold = (node['cpu']['total'] * 4)
      # Warning at x2 CPU count
      cpu_warning_threshold = (node['cpu']['total'] * 2)

      # Define our monitors
      node.set['rackspace_cloudmonitoring']['monitors'] = {
          'cpu' =>  { 'type' => 'agent.cpu', },
          'load' => { 'type'  => 'agent.load_average',
                      'alarm' => {
                          'notification_plan_id' => 'npTechnicalContactsEmail',
                          'CRITICAL' => {
                              'conditional' => "metric['5m'] > #{cpu_critical_threshold}",
                          },
                          'WARNING'  => {
                              'conditional' => "metric['5m'] > #{cpu_warning_threshold}",
                          },
                      },
          },

          'disk' => {
              'type' => 'agent.disk',
              'details' => { 'target' => '/dev/xvda1'},
          },
          'root_filesystem' => {
              'type' => 'agent.filesystem',
              'details' => { 'target' => '/'},
          },

          'web_check' => {
              'type' => 'remote.http',
              'target_hostname' => node['fqdn'],
              'monitoring_zones_poll' => [
                  'mzdfw',
                  'mziad',
                  'mzord'
              ],
              'details' => {
                  "url" => "http://#{node['ipaddress']}/",
                  "method" => "GET"
              }
          }
      }
      include_recipe "rackspace_cloudmonitoring::monitors"

    end

    if rackspace_backup == true

      node.set['rackspace_cloudbackup']['backups_defaults']['cloud_notify_email'] = 'fred.thompson@buildempire.co.uk'
      node.set['rackspace_cloudbackup']['backups'] =
          [
              { location: '/home' }
      ]
      include_recipe 'rackspace_cloudbackup'

      if node.attribute?("databox")
        if node["databox"].attribute?("databases")
          if node["databox"]["databases"]["mysql"]
            cron 'database-dump' do
              day '*'
              hour '2'
              minute '0'
              month '*'
              weekday '*'
              user 'root'
              mailto 'fred.thompson@buildempire.co.uk'
              command "mysqldump --user=root --password='#{node['databox']['db_root_password']}' --all-databases --skip-lock-tables | gzip > #{node["appbox"]["apps_dir"]}/database_latest.sql.gz"
              action :create
            end
          end
          if node["databox"]["databases"]["postgresql"]
          end
        end
      end

    end

  end

end