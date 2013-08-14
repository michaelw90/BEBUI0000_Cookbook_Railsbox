include_recipe 'apt'
package "libsqlite3-dev"
include_recipe 'sqlite'
include_recipe 'databox'
include_recipe 'rackbox'