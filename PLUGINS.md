# Plugin DSL

# `component`

Components are logical groupings of elements that make up an application.

```ruby
component "webserver" do
  description "My webserver that serves webs"
end
```

## `command`

Defines a command to be added to the mb cli generated for the plugin.

```ruby
  command "start" do
    description "Start the web server"
    execute do
      on("default") do
        service("apache").run(:start)
      end
    end
  end
```

### `description`

Provides text to be displayed in the help output generated for the plugin

```ruby
command "start" do
  description "Start the web server"
  # ...
end
```

### `execute`

Execute provides a place to define which actions are to be run during a command's run

```ruby
command "start" do
  execute do
    on("default") do
      service("server").run(:start)
    end
  end
end
```

#### `on`

`on` specifies a group to perform the actions contained in the block on. These actions will be performed in parallel. If actions need to be performed in sequence, use multiple `on` blocks.

Invocation of actions in `on` blocks follows this syntax: service("service_name").run(:action_name)

```ruby
command "start" do
  execute do
    on("default") do
      service("server").run(:start)
    end
  end
end
```

**`service`**

`service` is used to invoke actions in a `command` `on` block. See `on` for more details

```ruby
on("default") do
  service("server").run(:start)
end
```

## `description`

Provides text to be displayed in the help output generated for the plugin

```ruby
component "webserver" do
  description "serves the myface PHP web application"
end
```

## `group`

Groups allow motherbrain to identify nodes on which `actions` are taken.

```ruby
component "webserver" do
  description "My webserver that serves webs"

  group "default" do
    recipe "myface::webserver"
  end
end
```

Also supported

```ruby
  group "default" do
    role "webserver"
  end
```
```ruby
  group "default" do
    attribute "activemq.master", true
  end
```

### `recipe`

Used in a `group` to identify a server by a recipe entry on its runlist

```ruby
  group "default" do
    recipe "myface::webserver"
  end
```

### `role`

Used in a `group` to identify a server by a role entry on its runlist

```ruby
  group "default" do
    role "webserver"
  end
```

### `attribute`

Used in a `group` to identify a server by a node attribute

```ruby
  group "default" do
    attribute "activemq.master", true
  end
```



## `service`

Services are defined to represent the running processes on a given node that make up a component.

```ruby
component "webserver" do
  # ...
  service "apache" do
    # ...
  end
end
```

### `action`

Actions provide a way of interacting with the chef server to change the state of a service. Following the block, `chef-client` will be run on the nodes matched by the `group`.

```ruby
service "apache" do
  action :start do
    node_attribute 'myface.apache.enable', true
    node_attribute 'myface.apache.start', true
  end

  action :stop do
    node_attribute 'myface.apache.enable', false
    node_attribute 'myface.apache.start', false
  end
end
```

#### `node_attribute`

Used in an `action` to specify the value a node attribute should be set to

```ruby
action :start do
  node_attribute 'myface.apache.enable', true
  node_attribute 'myface.apache.start', true
end
```

# `cluster_bootstrap`

Cluster bootstrap identifies which `component` and `group` are to be bootstrapped when a `mb provision` is run.

```ruby
cluster_bootstrap do
  bootstrap("webserver::default")
end
```

## `bootstrap`

Used in a `cluster_bootstrap` block to specify what `component` and `group` should be bootstrapped during a provision

```ruby
cluster_bootstrap do
  bootstrap("webserver::default")
end
```