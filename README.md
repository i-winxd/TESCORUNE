# TESCORUNE

Fully-featured boss fight with some sort of... unexpected item

This is a Kristal mod that runs on the [Kristal](https://kristal.cc/) engine.

**HOW TO PLAY**:

- **BROWSER/WEB LINK (No downloads)**:
  - Direct "WASM" playable build: [tesco.i-win.cc](https://tesco.i-win.cc)
  - Page that has a button that redirects to the link above: https://i-win.cc/tesco
  - If this page doesn't load, your router might be blocking the page. In this case you'll have to download it.
  - Mobile is supported, but it might be hard to control and the game might lag. Controller hitboxes may not be what they seem. For example, if you are playing vertically, the Z hitbox is outside the game frame, near the bottom of your screen, in the same horizontal point. **The game MAY break at any time on mobile. Please do not click on any option that may fullscreen the game or change its resolution.** Audio will be compressed. **Mobile users: if the controls become unresponsive rotate your device and rotate it back.** There are options to change the difficulty by interacting with the **top right** set of boxes in the lobby (the empty ones).
- **ON YOUR COMPUTER**:
    - Download Kristal here: [Kristal Nightly Releases](https://kristal.cc/wiki/downloading#nightly-releases). Note that this is the nightly release and could break any time in the future. If that breaks, I've uploaded a mirror of a version that is guaranteed to work with my mod: [KRISTAL 1/4/2026 MIRROR](https://files.catbox.moe/dfv4wc.zip) (sorry Aussies but this link won't work for you). 
    - Extract `...-dev-win.zip`. Your files should be in the same directory. You should be able to see this:
    ![Downloaded Kristal](https://i.imgur.com/G2KguR6.png)
    - Run the Kristal executable once on your computer.
    - In Kristal, click "open mods folder".
    - Download this repository.
    ![Click to download](https://i.imgur.com/5SWJqT9.png)
    - Extract the repository and put it in the mods folder. Basically, I should see something like `.../AppData/Roaming/kristal/mods/TESCORUNE` at the end, where peeping in `.../AppData/Roaming/kristal/mods/TESCORUNE/README.md` should be there.
    ![What you should see](https://i.imgur.com/fCbQkfu.png)
    ![What you should see again](https://i.imgur.com/L2hs5i2.png)
    - **Back in the engine:** Press `CTRL+R`, go to "Play a mod" and TESCORUNE should be there.



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
- Yes, using the Yellow Soul funny cheat (spamming enter while holding Z) once during the fight will will change one attack for the rest of this encounter.

<details>
<summary>
    What happens if I spam big shots?
</summary>

    The bloons attack, which should be the last few attacks, spawns significantly more bloons.
</details>

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
- Any tweet, post, or video I make showcasing this with a link to this repository (not all platforms allow clickable links)
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
