#
# Cookbook Name:: cookbook_railsbox
# Recipe:: rackspace
#

if node['cookbook_railsbox']['rackspace']

  rackspace_username = node['cookbook_railsbox']['rackspace']['username']
  rackspace_api_key = node['cookbook_railsbox']['rackspace']['api_key']
  rackspace_auth_region = node['cookbook_railsbox']['rackspace']['auth_region']
  rackspace_endpoint = node['cookbook_railsbox']['rackspace']['endpoint']
  rackspace_container_name = node['cookbook_railsbox']['rackspace']['container_name']
  daily_backup_hour = node['cookbook_railsbox']['rackspace']['daily_backup_hour']
  daily_backup_minute = node['cookbook_railsbox']['rackspace']['daily_backup_minute']
  daily_database_backup_hour = node['cookbook_railsbox']['rackspace']['daily_database_backup_hour']
  daily_database_backup_minute = node['cookbook_railsbox']['rackspace']['daily_database_backup_minute']

  if rackspace_username != '' && rackspace_api_key != '' && rackspace_auth_region != ''

    gem_package "fog" do
      action :install
    end

    require 'fog'

    node.set['cloud_monitoring']['rackspace_username'] = rackspace_username
    node.set['cloud_monitoring']['rackspace_api_key'] = rackspace_api_key
    node.set['cloud_monitoring']['rackspace_auth_region'] = rackspace_auth_region
    include_recipe 'cloud_monitoring::agent'
  end

  if rackspace_username != '' && rackspace_api_key != '' && rackspace_endpoint != '' && rackspace_container_name != ''

    node.set['rackspace_cloud_backup']['rackspace_username'] = rackspace_username
    node.set['rackspace_cloud_backup']['rackspace_apikey'] = rackspace_api_key
    node.set['rackspace_cloud_backup']['rackspace_endpoint'] = rackspace_endpoint

    node.set['rackspace_cloud_backup']['backup_cron_hour'] = daily_backup_hour
    node.set['rackspace_cloud_backup']['backup_cron_day'] = '*'
    node.set['rackspace_cloud_backup']['backup_cron_weekday'] = '*'
    node.set['rackspace_cloud_backup']['backup_cron_month'] = '*'
    node.set['rackspace_cloud_backup']['backup_cron_minute'] = daily_backup_minute
    node.set['rackspace_cloud_backup']['backup_cron_user'] = 'root'

    node.set['rackspace_cloud_backup']['backup_container'] = rackspace_container_name
    node.set['rackspace_cloud_backup']['cloud_notify_email'] = 'fred.thompson@buildempire.co.uk'
    node.set['rackspace_cloud_backup']['backup_locations'] = [
      "/home"
    ]

    include_recipe 'rackspace-cloud-backup::cloud'

    if daily_database_backup_hour != '' && daily_database_backup_minute != ''

      if node.attribute?("databox")
        if node["databox"].attribute?("databases")
          if node["databox"]["databases"]["mysql"]
            cron 'database-dump' do
              day '*'
              hour daily_database_backup_hour
              minute daily_database_backup_minute
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