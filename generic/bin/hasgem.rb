#!/usr/bin/env ruby

require('rubygems')
require('optparse')

gem_name = nil
gem_ver  = nil
gem_load = nil

OptionParser.new do |parser|
  parser.on('--version=VER', 'Set gem version') {|v| gem_ver = v}
end.permute!(ARGV)

gem_name = ARGV.shift
gem_name = ARGV.shift if gem_name == 'install' and !ARGV.size.zero?

gem_load ||=
  case gem_name
  when 'rails'        then 'rails/version'
  when 'rb-appscript' then 'appscript'
  else gem_name
  end

gem_args = [gem_name]
gem_args << "=#{gem_ver}" unless gem_ver.nil? or gem_ver.empty?

begin
  gem(*gem_args)
  require(gem_load)
rescue Gem::LoadError => e
  exit(1)
rescue LoadError => e
  exit(1)
end
