# Kristal's current commit hash for this is:

`bbda70bc1469f8cd6e1d8a5b79350024865cb3e7`

## Getting this to work

In `.vscode/settings.json`, paste this

```
{
    "Lua.runtime.version": "LuaJIT",
    "Lua.diagnostics.disable": [
        "duplicate-set-field",
        "need-check-nil",
    ],
    "Lua.type.weakNilCheck": true,
    "Lua.type.weakUnionCheck": true,
    "Lua.runtime.builtin": {
        "utf8": "enable"
    },
    "Lua.runtime.special": {
        "modRequire": "require"
    },
    "Lua.workspace.library": [
        "${3rd}/love2d/library",
        "D:\\code\\deltarune_fangames\\Kristal" // Replace this with the filepath to the Kristal source code.
    ],
    "Lua.completion.autoRequire": false,
    "Lua.diagnostics.globals": [
    ]
}
```

## Kristal notes

The way modules are handled is probably not in the best way.
You cannot really have other helper methods without making them global, so oh well,
prepare for your namespace to be the worst it could be.

**When a module returns something, that the return value becomes global.**

That's it. No further elaboration.

Also if your mod breaks:

- `super` must never use `:` since it's not `super(super)`
- Certain methods must not be used in an init function
- other stuff
