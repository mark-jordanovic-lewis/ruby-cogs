# ruby-cogs

Basically self contained statemachines that can be configured for internal or external (complete/partial) state manipulation.

Can be nested inside another cog.

Messages can be passed from layers above (up to the main method) into cogs which are set up for external state change.

The idea is a fractal, hierarchical statemachine whose components are fractal hierarchical statemachines.

Use for whatever. Is probably pretty taxing on memory if your structures get too big.

####  Usage
###### To make a cog:
```ruby
my_cog = Cog.new(
  read_only: %i[read_only args here],
  accessors: %i[things here get writers_and_readers],
  args: {
    read_only: 'initialize',
    args: 'your',
    here: 'state.',
    things: 'Must include:',
    here: 'all accessors and read_onlys'
    get: 'and'
    writers_and_readers: 'is the argument for the passed block'
  }) do
  # edit state here, or don't it's up to you what it actually does
end
```
NB: `args` is a terrible name to use for an accessor, don't use `args`.

###### To run the cog block:
```
my_cog.turn
```
return value is last operation of the passed block.

###### Running cogs
```
my_cog.turn
# State may have changed
my_cog.turn
# State may have changed again
my_cog.turn
# you get the idea
...
```

###### To edit state:
You must have set at least one accessor
```
my_cog.things = 'new value'
```

###### To read state:
NB: Both accessors and read_onlys get readers.
```
my_cog.here
=> current value of read only state variable `here`
my_cog.things
=> current value of readable/writable state variable `things`
```
