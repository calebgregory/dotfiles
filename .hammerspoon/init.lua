-- watches config changes and reloads automatically
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

dofile('./app-shortcuts.lua')
dofile('./caffeine.lua')
dofile('./kid-lock.lua')
dofile('./pomodoro.lua')
