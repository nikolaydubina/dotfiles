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
    ["Finder"] = { size = "abs", w = 1100, h = 750 },
    ["Preview"] = { size = "abs", w = 800, h = 1000 }
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

    local fr = win:screen():frame()

    win:setFrame(hs.geometry({ 
        fr.w * x, 
        fr.h * y, 
        fr.w * w, 
        fr.h * h 
    }))
  end
end

local function adjustCenter(w, h)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end

    local fr = win:screen():frame()

    win:setFrame(hs.geometry({
        fr.w * 0.5 * (1 - w),
        fr.h * 0.5 * (1 - h),
        fr.w * w,
        fr.h * h
    }))
  end
end

local function adjustCenterAbs(w, h)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end

    local fr = win:screen():frame()

    win:setFrame(hs.geometry({
        0.5 * (fr.w - w),
        0.5 * (fr.h - h),
        w,
        h
    }))
  end
end

function adjustCenterSmall()
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
end

hs.hotkey.bind(mash.split, "up", adjust(0, 0, 1, 0.5))
hs.hotkey.bind(mash.split, "right", adjust(0.5, 0, 0.5, 1))
hs.hotkey.bind(mash.split, "down", adjust(0, 0.5, 1, 0.5))
hs.hotkey.bind(mash.split, "left", adjust(0, 0, 0.5, 1))
hs.hotkey.bind(mash.split, ",", function() hs.window.focusedWindow():maximize() end)
hs.hotkey.bind(mash.split, ".", adjustCenterSmall)

-- Wifi
function ssidChangedCallback()
    local ssid = hs.wifi.currentNetwork()
    if ssid then
        hs.notify.new({
            title='Network connected: ',
            informativeText=ssid
        }):send()
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

-- Show focused window size
hs.hotkey.bind(mash.utils, "/", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local fr = win:frame()
    w = fr.w
    h = fr.h

    hs.alert.show(w .. "x" .. h)
end)

-- Keep track of wakeups since last unlock
wokeup = {}
hs.caffeinate.watcher.new(function(eventType)
    if eventType == hs.caffeinate.watcher.screensDidWake 
        or eventType == hs.caffeinate.watcher.systemDidWake
    then
        table.insert(wokeup, os.date("%H:%M:%S"))
    elseif eventType == hs.caffeinate.watcher.screensDidUnlock then
        hs.notify.new({
            title="Woke up at:",
            informativeText=table.concat(wokeup, '\n')
        }):send()
        wokeup = {}
    end
end):start()

-- All set
hs.notify.new({
    title='Hammerspoon',
    informativeText='Config loaded'
}):send()
