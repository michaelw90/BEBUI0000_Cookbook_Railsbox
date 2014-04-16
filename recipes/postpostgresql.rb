#
# Cookbook Name:: cookbook_railsbox
# Recipe:: postpostgresql
#

execute "Psql template1 to UTF8" do
  user "postgres"
  command <<-SQL
echo "
UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE' LC_CTYPE='en_US.utf8'      LC_COLLATE='en_US.utf8';
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
\\c template1
VACUUM FREEZE;" | psql postgres -t
  SQL
# only_if '[ $(echo "select count(*) from pg_database where datname = \'template1\' and datcollate = \'en_US.utf8\'" |psql postgres -t) -eq 0 ]'
end