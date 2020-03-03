#!/usr/bin/env ruby
#
# @summary
#   This task is used to update a targets local hosts file.
#   It's only useful for hosts that cannot use DNS resolution.
#
# @note
#   This task must be run for each host file entry you want 
#   to add.
#
# @example How to run the task manually.
#   bolt task run 'common_code::ruby_update_hosts' \
#     --target testing \
#     --modulepath ./modules \
#     ip='10.10.10.100' \
#     fqdn='master.infra.net' 
#

require 'json'

# Read in the params
params = JSON.parse(STDIN.read)

hosts_file = '/etc/hosts'

content = File.read(hosts_file)
output = []

if content =~ (Regexp.new(Regexp.escape(params['fqdn'].split('.')[0])))
  content.split("\n").each do |line|
    if line =~ Regexp.new(Regexp.escape(params['fqdn'].split('.')[0]))
      output << "#{params['ip']} #{params['fqdn']} #{params['fqdn'].split('.')[0]}"
    else
      output << line
    end
  end
else
  output = content.split("\n")
  output << "#{params['ip']} #{params['fqdn']} #{params['fqdn'].split('.')[0]}"
end

test = File.new('/etc/hosts', 'w')
test.write(output.join("\n") + "\n")
test.close
