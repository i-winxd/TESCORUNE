# TESCORUNE

**HOW TO PLAY**: If a field says *TBA* it means I didn't add it yet.

- You can play this mod in your browser using this link: TBA

You can also load this into Kristal if you have Kristal installed.
Alternatively, I can provide a pre-compiled executable: TBA


**VERSION COMPATABILITY:**

This works for the version of Kristal's main branch 
committed around Dec. 12 and around Sept. 7th.

## Setting the development environment

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

## Issues

You are welcome to open issues if you encounter any issues playing this.
Issues are not guaranteed to be addressed (this is just for expectations) although it depends.

Pull requests that count as modifying content (apart from just bugfixes) are unlikely to be accepted.
