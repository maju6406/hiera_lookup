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

  unless explain == 'no'
    explain = ' --explain '
  end

  unless node.to_s.empty?
    explain = " --node #{node} "
  end

  unless environment.to_s.empty?
    explain = " --environment #{environment} "
  end


  cmd = ['/opt/puppetlabs/puppet/bin/puppet', 'lookup', key, environment, node, explain]
  stdout, stderr, status = Open3.capture3( *cmd)
  {
    stdout: stdout.strip,
    stderr: stderr.strip,
    exit_code: status.exitstatus,
  }
end

results = {}
params = JSON.parse(STDIN.read)

keys = params['keys'].split(',')
node = params['certname']
environment = params['environment']
explain = params['explain']

keys.each do |key|
  results[key] = {}

  output = hiera_lookup(key, environment, node, explain)
  results[key][:result] = if output[:exit_code].zero?
                                 "#{output[:out]}"
                               else
                                 "There was an looking up #{key}: #{output[:stderr]}"
                               end
end

puts results.to_json
