[![Build Status](https://travis-ci.org/maju6406/lookup.svg?branch=master)](https://travis-ci.org/maju6406/lookup)
[![Puppet Forge](https://img.shields.io/puppetforge/v/beersy/lookup.svg)](https://forge.puppetlabs.com/beersy/lookup)

# Puppet Hiera Lookup Task

This module adds a Task for perform puppet cert signing.

For Puppet Enterprise users, this means you can allow users or admins to sign nodes without giving them SSH access to your Puppet master! The ability to run this task remotely or via the Console is gated and tracked by the [RBAC system](https://puppet.com/docs/pe/2017.3/rbac/managing_access.html) built in to PE.

## Requirements

This module is compatible with Puppet Enterprise and Puppet Bolt.

* To [run tasks with Puppet Enterprise](https://puppet.com/docs/pe/2017.3/orchestrator/running_tasks.html), PE 2017.3 or later must be used.

* To [run tasks with Puppet Bolt](https://puppet.com/docs/bolt/0.x/running_tasks_and_plans_with_bolt.html), Bolt 0.5 or later must be installed on the machine from which you are running task commands. The master receiving the task must have SSH enabled.

## Usage

### Puppet Enterprise Tasks

With Puppet Enterprise 2017.3 or higher, you can run this task [from the console](https://puppet.com/docs/pe/2017.3/orchestrator/running_tasks_in_the_console.html) or the command line.

Here's a command line example where we are signing the `foo`, `bar`, and `baz` nodes from the Puppet master, `master.corp.net`:

```shell
[abir@workstation]$ puppet task run lookup keys=foo,bar,baz -n master.corp.net

Starting job ...
New job ID: 24
Nodes: 1

Started on master.corp.net ...
Finished on node master.corp.net
  bar :
    result : Cert successfully signed for bar

  baz :
    result : Cert successfully signed for baz

  foo :
    result : Cert successfully signed for foo

Job completed. 1/1 nodes succeeded.
Duration: 6 sec
```

### Bolt

With [Bolt](https://puppet.com/docs/bolt/0.x/running_tasks_and_plans_with_bolt.html), you can run this task on the command line like so:

```shell
bolt task run lookup keys=foo,bar,baz --nodes master.corp.net
```

## Parameters

* `keys`: A comma-separated list of keys to look up
* `environment`: Environment to use for look up (optional)
* `certname`: Node to use for look up (optional)
* `explain`: Enable explain (optional). Defaults to yes.
