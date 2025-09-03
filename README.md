# Kristal's current commit hash for this is:

`bbda70bc1469f8cd6e1d8a5b79350024865cb3e7`

# Getting this to work

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