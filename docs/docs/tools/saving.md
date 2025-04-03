---
title: Saving
layout: default
parent: Tools
---

# Saving

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