#
# Cookbook Name:: cookbook_railsbox
# Recipe:: locale
#

execute 'Update locale' do
  lang = 'en_GB.utf8'
  language = 'en_GB:'
  lc_all = 'en_GB.utf8'
  command_string = "update-locale LANG=#{lang}"
  command_string << " LANGUAGE=#{language}" unless language.nil?
  command_string << " LC_ALL=#{lc_all}" unless lc_all.nil?
  Chef::Log.debug("locale command is #{command_string.inspect}")
  command command_string
  command "locale-gen #{lang}"
  command "dpkg-reconfigure locales"
end

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_GB.utf8"