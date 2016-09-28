
# Mixin v1.0.0 ![stable](https://img.shields.io/badge/stability-stable-4EBA0F.svg?style=flat)

`Mixin` creation is split into three phases:

- Create mixin interface

- Define mixin implementation (by buffering interface calls)

- Apply mixin to object with same interface

An error is thrown when the target object is missing a required method.

```coffee
Mixin = require "Mixin"

# We want to expose a `defineValues` method for mixins to use.
SomeMixin = Mixin
  methods: ["defineValues"]

# Multiple mixins may want to share the same methods.
mixin = SomeMixin()

# Any method calls are directly mirrored onto the type applying this mixin.
mixin.defineValues {a: 1}

# Every mixin has a `finalize` method.
# The returned function can be passed any object with the same methods as this mixin.
applyMixin = mixin.finalize()

# The `defineValues` method below will be called with {a: 1}
applyMixin
  defineValues: (values) ->
    console.log JSON.stringify values
```
