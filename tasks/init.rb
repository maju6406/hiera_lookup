#!/opt/puppetlabs/puppet/bin/ruby
#
# Puppet Task to perform hiera lookups
#
# Parameters:
# keys: A comma-separated list of keys to look up
# environment: Environment to use for look up (optional)
# certname: Node to use for look up (optional)
# explain: Enable explain (optional). Defaults to yes.
#
require 'puppet'
require 'open3'

Puppet.initialize_settings

def hiera_lookup(key, environment, node, explain)

  if explain == 'no'
    explain = ''
  else
    explain = '--explain' 
  end

  if node.nil?
    node = ''
  else  
    node = "--node #{node}"
  end

  if environment.nil?
    environment = ''
  else  
    environment = "--environment #{environment}"
  end
  cmd = ['/opt/puppetlabs/puppet/bin/puppet', 'lookup', key, explain, environment, node ]

  puts cmd.join(" ")

  stdout, stderr, status = Open3.capture3( *cmd)
  {
    stdout: stdout.strip,
    stderr: stderr.strip,
    exit_code: status.exitstatus,
  }
end

params = JSON.parse(STDIN.read)

keys = params['keys'].split(',')
node = params['certname']
environment = params['environment']
explain = params['explain']

keys.each do |key|
  output = hiera_lookup(key, environment, node, explain)
  puts "------------------------"  
  puts "#{key}"  
  puts "-----------"  
  if output[:exit_code].zero?
    puts "#{output[:stdout]}"
  else
    "There was an looking up #{key}: #{output[:stderr]}"
  end
  puts "------------------------"  
end

