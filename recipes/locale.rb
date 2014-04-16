#
# Cookbook Name:: cookbook_railsbox
# Recipe:: locale
#



execute 'Update locale' do
  lang = 'en_GB.UTF-8'
  language = 'en_GB.UTF-8'
  lc_all = 'en_GB.UTF-8'
  command_string = "sudo update-locale LANG=#{lang}"
  command_string << " LANGUAGE=#{language}" unless language.nil?
  command_string << " LC_ALL=#{lc_all}" unless lc_all.nil?
  Chef::Log.info("locale command is #{command_string.inspect}")
  command command_string
  command "sudo locale-gen #{lang}"
  Chef::Log.info("locale-gen #{lang}")
  command "sudo dpkg-reconfigure locales"
end

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = 'en_GB.UTF-8'