hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()

  hs.application.launchOrFocus("Sublime Text")
  hs.application.launchOrFocus("Terminal")
  hs.application.launchOrFocus("Safari")

  local laptopScreen = "Color LCD"
  local windowLayout = {
      {"Sublime Text",  nil,  laptopScreen, {x=0,y=0,w=0.5,h=0.80}, nil, nil},
      {"Safari",        nil,  laptopScreen, hs.layout.right50,      nil, nil},
      {"Terminal",      nil,  laptopScreen, {x=0,y=0.80,w=0.5,h=0.20}, nil, nil},
  }
  hs.layout.apply(windowLayout)
end)

hs.hotkey.bind({"ctrl"}, "T", function()

    hs.applescript([[try
  tell application "Finder" to set the this_folder ¬
   to (folder of the front window) as alias
on error -- no open folder windows
  set the this_folder to path to desktop folder as alias
end try

set thefilename to text returned of (display dialog ¬
 "Create file named:" default answer "filename.txt")
set thefullpath to POSIX path of this_folder & thefilename
do shell script "touch \"" & thefullpath & "\""]])


end)


local wifiWatcher = nil
local homeSSID = "Superted"
local lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(25)
        hs.alert.show("Set the volume to 25")
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
        hs.alert.show("Set the volume to 0")
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")