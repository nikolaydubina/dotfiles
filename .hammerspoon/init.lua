-- Config
local mash = {
  split   = {"ctrl", "cmd"},
  utils   = {"ctrl", "alt"}
}

local centeredWindowRatios = {
  small = { w = 0.8, h = 0.8 }, -- screen width < 2560
  large = { w = 0.66, h = 0.66 } -- screen width >= 2560
}

local appSettings = {
    ["Finder"] = { size = "abs", w = 1100, h = 750 }
}

-- Setup
--hs.window.setFrameCorrectness = true
hs.window.animationDuration = 0
--local logger = hs.logger.new("config", "verbose")

-- Reload config
hs.hotkey.bind(mash.utils, "-", function()
  hs.reload()
end)

-- Resize windows
local function adjust(x, y, w, h)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end

    local f = win:frame()
    local fr = win:screen():frame()

    f.x = fr.w * x
    f.y = fr.h * y
    f.w = fr.w * w 
    f.h = fr.h * h

    win:setFrame(f)
  end
end

local function adjustCenter(w, h)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end

    local f = win:frame()
    local fr = win:screen():frame()

    f.x = fr.w * 0.5 * (1 - w)
    f.y = fr.h * 0.5 * (1 - h)
    f.w = fr.w * w
    f.h = fr.h * h

    win:setFrame(f)
  end
end

local function adjustCenterAbs(w, h)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end

    local f = win:frame()
    local fr = win:screen():frame()

    f.x = 0.5 * (fr.w - w)
    f.y = 0.5 * (fr.h - h)
    f.w = w
    f.h = h

    win:setFrame(f)
  end
end

hs.hotkey.bind(mash.split, "up", adjust(0, 0, 1, 0.5))
hs.hotkey.bind(mash.split, "right", adjust(0.5, 0, 0.5, 1))
hs.hotkey.bind(mash.split, "down", adjust(0, 0.5, 1, 0.5))
hs.hotkey.bind(mash.split, "left", adjust(0, 0, 0.5, 1))

-- full
hs.hotkey.bind(mash.split, ",", adjustCenter(1, 1))

-- center small
hs.hotkey.bind(mash.split, ".", function()
  local win = hs.window.focusedWindow()
  if not win then return end

  local app = win:application()
  if app then
    local set = appSettings[app:name()]
    if set then
        if set.size == "abs" then
            adjustCenterAbs(set.w, set.h)()
        else
            adjustCenter(set.w, set.h)()
        end
        return
    end
  end

  local size = win:screen():frame().w >= 2560 and "large" or "small"
  adjustCenter(centeredWindowRatios[size].w, centeredWindowRatios[size].h)()
end)

-- Wifi
function ssidChangedCallback()
    local ssid = hs.wifi.currentNetwork()
    if ssid then
      hs.alert.show("Network connected: " .. ssid)
    end
end

hs.wifi.watcher.new(ssidChangedCallback):start()

-- Re-Enable Wifi
hs.hotkey.bind(mash.utils, "r", function()
  hs.wifi.setPower(false, "en0")
  hs.timer.doAfter(2, function() hs.wifi.setPower(true, "en0") end)
end)

-- Hints
hs.hints.showTitleThresh = 0
hs.hotkey.bind(mash.utils, "e", function()
    hs.hints.windowHints()
end)

-- All set
hs.alert.show("Hammerspoon!")
