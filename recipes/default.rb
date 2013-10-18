#
# Cookbook Name:: cookbook_railsbox
# Recipe:: default
#

include_recipe "cookbook_railsbox::locale"
include_recipe 'apt'
package "libsqlite3-dev"
include_recipe 'sqlite'
if node.attribute?(:new_relic)
  include_recipe 'newrelic-sysmond'
end
include_recipe 'databox'
include_recipe 'rackbox'
include_recipe 'imagemagick'