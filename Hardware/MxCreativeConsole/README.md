# [Brainstorming] Coding and Vibe Coding with the Logitech MX Creative Console

Just found out about this device yesterday, and was looking for anyone online who has tried this with Visual Studio, Rider, or VSCode. Even generative AI IDE tools like Copilot/Cursor/Windsurf.

Neat features I like about the Logitech MX Creative Console:

* Automatically changes shortcuts based on what app you have opened/focused.

The Logitech MX Creative Console is effectively a direct replacement for [Loupedeck CT (Creative Tool)](https://loupedeck.com/us/products/loupedeck-ct/), and Loupedeck actually has a VS Code plug-in already: [https://marketplace.loupedeck.com/asset/VisualCode](https://marketplace.loupedeck.com/asset/VisualCode) Since MX Creative Console has been around for much shorter, it has way less in its market place - currently the main focus is Adobe Creative Suite. See: Plugins [https://marketplace.logi.com/plugins/en/4?sort=mostRecent&platform=9](https://marketplace.logi.com/plugins/en/4?sort=mostRecent&platform=9) and Profiles [https://marketplace.logi.com/profiles/en/4?sort=mostRecent&platform=9](https://marketplace.logi.com/profiles/en/4?sort=mostRecent&platform=9). Logitech acquired Loupedeck and was able to significantly lower the price point from $599 to $199.

Especially with the push for generative AI, I've been thinking about how to make working with agentic workflows less painful. [oai.azure.com](http://oai.azure.com) is really annoying to work with - it literally looks like some insane machine someone built when you login.  And the Visual Studio 2022 Copilot feels...bolted on.

Most chat bots have common shortcuts. For example, ChatGPT has:

* **New Chat:** Ctrl+Shift+O
* **Toggle Sidebar:** Ctrl+Shift+S
* **Focus Chat Input:** Shift+Esc
* **Copy Last Code Block:** Ctrl+Shift+;
* **Delete Chat:** Ctrl+Shift+X
* **Copy Last Response:** Ctrl+Shift+C
* **Show all Shortcuts:** Ctrl+\\\\ (backslash)

Some ideas I have so far:

1. DotNet MSBuild Lifecycle Shortcuts
   1. git clean
   2. Clean
   3. Restore
   4. Build
   5. Debug
   6. Debug Reload
   7. Test
   8. Pack
   9. Publish
   10. Other (unique to my own process)
   11. Build Database Migrations
   12. Run Database Migrations against LocalDB
   13. Run Database Migrations against remote SQL Server instance
   14. Create Database Clone against remote SQL Server instance
   15. Reset Database Clone against remote SQL Server instance (Drop and re-Create)
2. When Visual Studio is in debug mode,
   1. keys to:
      1. Step Into (F11)
      2. Step Over (F10)
   2. key chords to:
      1. When Chrome is focused, open developer tools, docked to the right.
   3. control Quick Watch with the creative console Action Ring
      1. Copilot could suggest items to Quick Watch
      2. From that suggestion list, scroll the wheel to select what items you want to see in quick watch
   4. using ideas from Loupedeck Vegas Pro timeline editing and Visual Studio time travel debugging to create non-linear view of program time - not sure this is a good idea, just a half done in the oven thought at this point
3. When coding, refactoring short cuts to:
   1. Control + . - apply default refactoring suggestion
   2. ReSharper shortcuts based on current cursor location
      1. I almost never use the option to lift a code snippet into a local function, as it increases nesting, but prefer private methods instead. A shortcut to just do that would be awesome.

If people find this interesting, maybe we can brainstorm this further in a GitHub repo and build a design doc for how this might work and make it a living document.
