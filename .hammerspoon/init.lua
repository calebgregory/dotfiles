-- watches config changes and reloads automatically
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- "handrolled" caffeine from the hammerspoon Getting Started doc
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("☕️")
    else
        caffeine:setTitle("😴")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function ()
  state = hs.caffeinate.toggle("displayIdle")

  if state then
    hs.alert.show("Caffeine: ON")
  else
    hs.alert.show("Caffeine: OFF")
  end

  setCaffeineDisplay(state)
end)

hs.hotkey.bind({"cmd", "ctrl"}, ";", function()
    hs.application.launchOrFocus("WezTerm.app")
end)

---

------------------------------------------------------------------
-- Kid-Lock (mouse move + clicks allowed) with countdown, sounds,
-- volume/media key allowance, menu toggle, auto-unlock timer.
----------------------------------------------------------------

-- === Settings ===
local UNLOCK_MODS = {"ctrl","alt","cmd","shift"} -- ⌃⌥⌘⇧
local UNLOCK_KEY  = "L"
local AUTO_UNLOCK_MINUTES = 30

-- System sounds: try "Submarine", "Glass", "Pop", "Tink", "Funk", "Hero"
local LOCK_SOUND_NAME   = "Submarine"
local UNLOCK_SOUND_NAME = "Glass"

-- === State ===
local locked        = false
local alertId       = nil
local autoTimer     = nil     -- one-shot auto-unlock timer
local tickTimer     = nil     -- countdown refresher (every second)
local lockDeadline  = nil     -- os.time() when it should auto-unlock
local menu          = hs.menubar.new(true)

local EMOJI_LOCKED, EMOJI_UNLOCKED = "🔒", "🔓"

-- Blocked events (mouse move & clicks NOT tapped, so they still work)
local blockedEventTypes = {
  hs.eventtap.event.types.keyDown,
  hs.eventtap.event.types.keyUp,
  -- hs.eventtap.event.types.flagsChanged,

  hs.eventtap.event.types.leftMouseDragged,
  hs.eventtap.event.types.rightMouseDragged,
  hs.eventtap.event.types.otherMouseDragged,

  hs.eventtap.event.types.scrollWheel,
  hs.eventtap.event.types.gesture,
  hs.eventtap.event.types.magnify,
  hs.eventtap.event.types.swipe,
  hs.eventtap.event.types.rotate,
  hs.eventtap.event.types.pressure,
  hs.eventtap.event.types.directTouch,
}

-- Some keyboards send F-keys for media; whitelist those when locked.
local ALLOWLIST_KEYCODES = {
  [hs.keycodes.map["f10"]] = true, -- mute
  [hs.keycodes.map["f11"]] = true, -- vol down
  [hs.keycodes.map["f12"]] = true, -- vol up
}

-- Also let system-defined media keys through (volume/brightness/play, etc.)
local mediaTap = hs.eventtap.new({hs.eventtap.event.types.systemDefined}, function(_)
  return false -- don't consume; allow system to handle
end)

-- --- Helpers ---
local function isUnlockEvent(e)
  if e:getType() ~= hs.eventtap.event.types.keyDown then return false end
  local mods = e:getFlags()
  local need = {ctrl=true, alt=true, cmd=true, shift=true}
  for k,_ in pairs(need) do if not mods[k] then return false end end
  for k,v in pairs(mods) do if v and not need[k] then return false end end
  return hs.keycodes.map[UNLOCK_KEY:lower()] == e:getKeyCode()
end

local function playSound(name)
  if not name or name == "" then return end
  local snd = hs.sound.getByName(name)
  if snd then snd:play() end
end

local function fmtMMSS(secs)
  secs = math.max(0, math.floor(secs))
  local m = math.floor(secs / 60)
  local s = secs % 60
  return string.format("%d:%02d", m, s)
end

local function remainingSeconds()
  if not lockDeadline then return 0 end
  return math.max(0, lockDeadline - os.time())
end

local function setMenuLocked(isLocked)
  if not menu then return end
  if isLocked then
    local ttl = fmtMMSS(remainingSeconds())
    menu:setTitle(EMOJI_LOCKED .. " " .. ttl)
    menu:setTooltip("Input Locked — " .. ttl .. " remaining (click to unlock)")
  else
    menu:setTitle(EMOJI_UNLOCKED)
    menu:setTooltip("Input Unlocked (click to lock)")
  end
end

local function refreshCountdown()
  if not locked then return end
  local secs = remainingSeconds()
  setMenuLocked(true)
  if secs <= 0 then
    -- Safety: in case doAfter didn’t fire yet, unlock here
    hs.timer.doAfter(0.01, function() setLocked(false) end)
  end
end

-- Event taps
local blocker = hs.eventtap.new(blockedEventTypes, function(e)
  if isUnlockEvent(e) then return false end
  if locked and e:getType() == hs.eventtap.event.types.keyDown then
    if ALLOWLIST_KEYCODES[e:getKeyCode()] then return false end
  end
  return true
end)

local unlockTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
  if locked and isUnlockEvent(e) then
    setLocked(false)
    return true  -- consume the key so it doesn't type "l" anywhere
  end
  return false
end)

-- Timer management
local function stopTimers()
  if autoTimer then autoTimer:stop(); autoTimer = nil end
  if tickTimer then tickTimer:stop(); tickTimer = nil end
end

-- Core lock/unlock
function setLocked(on)
  if on and not locked then
    locked = true
    blocker:start()
    unlockTap:start()
    mediaTap:start()
    stopTimers()
    lockDeadline = os.time() + (AUTO_UNLOCK_MINUTES * 60)
    autoTimer = hs.timer.doAfter(AUTO_UNLOCK_MINUTES * 60, function() setLocked(false) end)
    tickTimer = hs.timer.doEvery(1, refreshCountdown) -- update mm:ss every second
    setMenuLocked(true)
    if alertId then hs.alert.closeSpecific(alertId) end
    alertId = hs.alert.show("Input Locked", 1.0)
    playSound(LOCK_SOUND_NAME)
  elseif (not on) and locked then
    locked = false
    blocker:stop()
    unlockTap:stop()
    mediaTap:stop()
    stopTimers()
    lockDeadline = nil
    setMenuLocked(false)
    if alertId then hs.alert.closeSpecific(alertId); alertId = nil end
    hs.alert.show("Input Unlocked", 1.0)
    playSound(UNLOCK_SOUND_NAME)
  end
end

-- Menu bar toggle
if menu then
  menu:setClickCallback(function() setLocked(not locked) end)
  setMenuLocked(false)
end

-- Global hotkey toggle
hs.hotkey.bind(UNLOCK_MODS, UNLOCK_KEY, function() setLocked(not locked) end)

-- Optional: start locked on config load
-- setLocked(true)
----------------------------------------------------------------

