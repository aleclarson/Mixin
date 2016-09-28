
{frozen} = require "Property"

assertType = require "assertType"
cloneArgs = require "cloneArgs"
isDev = require "isDev"
sync = require "sync"

exports.create = (config) ->

  isDev and
  assertType config, Object

  prototype = {}
  if Array.isArray (methods = config.methods)
    for key in methods
      prototype[key] = createMethod key

  if config.extends and (methods = config.extends.prototype)
    for key, value of methods
      continue if prototype[key] isnt undefined
      continue if typeof value isnt "function"
      prototype[key] = createMethod key

  mixinType = ->
    mixin = Object.create prototype

    calls = []
    mixin.apply = (type) ->
      for {key, args} in calls
        method = type[key]
        if isDev and not method
          throw Error "Mixin expected method to exist: '#{key}'"
        method.apply type, args
      return

    frozen.define mixin, "_calls", {value: calls}
    return mixin

  mixinType.prototype = prototype
  return mixinType

createMethod = (key) -> () ->
  args = cloneArgs arguments
  @_calls.push {key, args}
  return
