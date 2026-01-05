# TESCORUNE

Fully-featured boss fight with some sort of... unexpected item

This is a Kristal mod that runs on the [Kristal](https://kristal.cc/) engine.

**HOW TO PLAY**:

- **BROWSER/WEB LINK (No downloads)**:
  - Direct "WASM" playable build: [tesco.i-win.cc](https://tesco.i-win.cc)
  - Page that has a button that redirects to the link above, which is better to share to avoid mobile user griveances: https://i-win.cc/tesco
  - Mobile is supported, but it might be hard to control and the game might lag. Controller hitboxes may not be what they seem. For example, if you are playing vertically, the Z hitbox is outside the game frame, near the bottom of your screen, in the same horizontal point. **The game MAY break at any time on mobile. Please do not click on any option that may fullscreen the game or change its resolution.** Audio will be compressed.
- **AS AN EXECUTABLE DOWNLOAD**: TBA. Usually better performance, audio is not compressed so file size will be larger. Be careful about doing this and putting this repository in the mods folder since this results in mod ID conflicts.
- YOU HAVE AN EXISTING KRISTAL INSTANCE: Download this repository as a ZIP, unzip it to where you would put your Kristal mods. This is compatible with the version of Kristal committed between July 2025 and has been tested for the commit at December 12, 2025. However, since Kristal might not be very future-proof, the web or executable downloads might be better. Kristal, as of 1/4/2026, does not support running on the web or mobile touch controls without modifying the code, which are features I had to implement myself.

**VERSION COMPATABILITY**

This works for the version of Kristal's main branch 
committed around Dec. 12 and around Sept. 7th.

Kristal has made changes to the engine between that timeframe that may make older mods incompatible. I've taken these changes into account to ensure this mod doesn't break due to sudden feature changes.

The executable download uses a version of Kristal
that was last committed on September 2025 because I can't merge upstream without breaking my changes.

## Gameplay Troubleshooting

In the first room:

- The center shelf gives you `D$10`. You can repeat this as much as you like. There is a shop somewhere for you to restock on items in case you toss them.
- The shelf on the center-right allows you to change or mute the music. If you're streaming this, set the music to `Abridged` to avoid potential issues.
- The shelf on the top-right allows you to change the difficulty of the boss fight. This only impacts damage.
  Mobile users may want to ease up the difficulty to compensate the fact that the game is harder to control.

Challenges:

- No hit the boss, or play on a harder difficulty.
- Finish the boss after consuming two `Instant Coffee` items at the start of the battle, effectively making all bullets spawn and move twice as fast.

## Filing Bug Reports

You are welcome to open issues if you encounter any issues playing this.
Issues are not guaranteed to be addressed (this is just for expectations) although it depends.

Pull requests are not guaranteed; I might not be able to monitor them frequently.

Please do not submit issues to the Kristal repository *unless* you are playing on the latest version
of the engine. The web-based version and the executable release use an outdated version.

Any forks must make clear the modifications that have been made.

## Referencing this mod

If you record yourself playing this, you may credit using:

- The link to this repository
- The link to the playable web version
- Any tweet, post, or video I make showcasing this
- My social media pages

If you got this mod anywhere but here, someone could've added malicious code to it.

You can definitely learn by reading the code. If you need
to copy a large segment of the code, you can cite
it by pasting in the link to the file you copied from, maybe as a permalink w/ the lines referenced.
However, I do not guarantee tech support. **I cannot guarantee that I implemented things in the best way.**

## Programming Advice

As much as people like jumping into things right away, I do not recommend attempting to make a mod yourself without the proper background. If you've taken at least a semester worth of programming in any school where you're able to grasp stuff
very clearly, you should be fine (and anything beyond that, that isn't specific to this framework won't help you that much). Ideally, you should know
why things work a specific way, and when an error occurs, know what's causing the error.


## Credits

- Engine: https://kristal.cc
- Gaster Blaster lib - Scarm, JustAnotherRandomUser
- Yellow Soul lib - vitellaryjr
- Big Shot FLP - Nini
- Deltarune is made by Toby Fox and his team (obviously)

## Disclaimer

This mod is provided as-is, with no warranty.

## Appendix

### Setting the development environment

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