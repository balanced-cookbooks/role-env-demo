role-env-demo
=============

A quick example of how to do application environments with a cookbook.

Setting app_environment
-----------------------

The most important piece is in [attributes/default.rb](/attributes/default.rb):

```ruby
candidates = node['recipes'] \
  .select {|r| r.start_with?('role-env-demo') } \
  .map {|r| r = r['role-env-demo::'.length..-1] || node.chef_environment}
raise "More than one candidate environment found: #{candidates.join(', ')}" if candidates.size > 1

default['app_environment'] = candidates.first
```

This parses the list of recipes looking for something like `role-env-demo` or
`role-env-demo::prod`. If more than one is found, an error is raised, otherwise
then name of the recipe is set as a node attribute `app_environment`.

After this in `attributes/default.rb` you can have any default attributes you
want to apply to all environments subject to later overrides.

App environment settings
------------------------

An example of a simple app environment is in
[attributes/test.rb](attributes/test.rb). All app environments start with a
similar header:

```ruby
include_attribute 'role-env-demo'
return unless node['app_environment'] == 'test'
```

This forces the `default.rb` to run to ensure the `node['app_environment']` has
been set, and then only continues if the current node is in the requested app
environment. In cases of multi-level inheritance, such as with the `inherit` app
environment, the conditional [may look slightly
different](attributes/prod.rb#L20).

After this header, you put standard attribute default/overrides that will apply
to only this app environment.

Recipes
-------

In most role cookbooks, the [default recipe](recipes/default.rb) will just use
`include_recipe` to pull in the desired recipes.

In addition to this, we also add recipes for each app environment which just
[include the default](recipes/prod.rb#L19).

Why?
----

Why not just use Chef environments? Sometimes you want to deploy slightly
different applications in the same Chef environment. An example would be
launching a new branch of your code in the test environment. You could copy the
Chef environment and tweak the settings you want, but this results in a lot of
duplicated configuration which is error prone and difficult to update.
Additionally, even though it is slightly different, this hypothetical new
application cluster is still semantically in the "test" environment, and
currently Chef environments don't have any kind of heirarchical relationship.
