<img src="addons/blankit/branding/blankit_color_white_horizontal_logo.png" width="512" alt="Blankit logo">

> ⚠️ Blankit is in active development as part of a secret Snoozy Kazoo project.
>
> Blankit's systems are very much a work-in-progress, and should not be used in production ready projects.
>
> v1 is estimated to be uploaded around that project's release.
>
> Thank you for your patience! 😌

Wrap your Godot game project in a cozy Blankit!

Blankit is an all-in-one framework for making games in the Godot Engine. Blankit contains a ton of systems to allow you to jump straight into gameplay programming, without worrying about the backend.

## But why? 🤔

After working on Turnip Boy Commits Tax Evasion, Turnip Boy Robs a Bank, and Hobnobbers, I realized how much time is wasted working on duplicates of the same few systems. Blankit is my attempt to resolve that for myself and anyone who chooses to adopt it!

Blankit is a bunch of simple versions of these systems with an intuitive workflow and an easy to use editor for quickly setting up and modifying your project's settings. Functions are easy to use and remember, and since the code is simple it's easy to maintain and keep stable with new Godot updates.

## Installation 🛠️

### Godot Asset Library

1. Open your Godot project
2. Navigate to the AssetLib tab
3. Search for "Blankit"
4. Download and install the addon

### Manual Installation

1. Download the latest release from the GitHub repository
2. Extract the contents
3. Drag the addons folder into your project's directory

## Systems 🧰

### Blankit Saving 💾

Blankit Saving is designed with save slots and multiple users on one machine in mind. By default, Blankit uses a "default" profile by default, but the system features a profile setter, which allows you to seperate save files in whichever way works for your game.

```gdscript
# You can set a profile with this code
BlankitSaving.set_profile("yukon")
```

After that, you can very easily save & load to a file within that profile by doing the following:

```gdscript
# Load the file "game"
BlankitSaving.load("game")

# Save the file "game"
BlankitSaving.save("game")
```

You can also save a file into a "shared" profile, which is great for options! This is done by just adding a true to the second parameter in the save & load functions.

```gdscript
# Load the file "options" in shared profile
BlankitSaving.load("options", true)

# Save the file "options" in shared profile
BlankitSaving.save("options", true)
```

Lastly, you can set and get data in a file by doing the following:

```gdscript
BlankitSaving.set_value("game", "high_score", 100)

BlankitSaving.get_value("game", "high_score", 0) # The 0 here is a default value if there is no data set
```

### Other features coming soon! ⏳

- Game configurations so you can build and maintain a demo and showcase version all in one project file!
- Smooth scene loading with support for pre-built or custom transitions!
- An achievement system with a backup local save file for API call failures.
- Remote Configurations that you can host on your website that Blankit will automatically download and allow you to pull from on launch.
- An API Handling system that allows you to plug-and-play SDKs after building the initial connection.
- Pausing and time management.
- Support for custom modals.
- And more! (If you or I can think of anything cool!)

## Support 🙋‍♀️

If you encounter any issues or have questions, please [submit an issue](https://github.com/yukonmakesgames/blankit/issues)!