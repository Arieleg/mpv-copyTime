require 'mp'
require 'mp.msg'

-- Copy the current time of the video to clipboard.

WINDOWS = 2
UNIX = 3

local function platform_type()
    local utils = require 'mp.utils'
    local workdir = utils.to_string(mp.get_property_native("working-directory"))
    if string.find(workdir, "\\") then
        return WINDOWS
    else
        return UNIX
    end
end

local function command_exists(cmd)
    local pipe = io.popen("type " .. cmd .. " > /dev/null 2> /dev/null; printf \"$?\"", "r")
    exists = pipe:read() == "0"
    pipe:close()

    -- show error if command not exists
    if not exists and cmd == "pbcopy" then
        mp.msg.error(cmd .. " package not found! please install it (MacOS-only).")
    elseif not exists then
        mp.msg.error(cmd .. " package not found! please install it.")
    end

    return exists
end

-- reference for io.popen:
-- https://pubs.opengroup.org/onlinepubs/009695399/functions/popen.html
local function display_servers(cmd)
    local pipe = io.popen("echo $XDG_SESSION_TYPE", "r")
    exists = pipe:read() == cmd
    pipe:close()
    return exists
end

local function get_clipboard_cmd()
    if display_servers("x11") and command_exists("xclip") then
        return "xclip -silent -in -selection clipboard"
    elseif display_servers("wayland") and command_exists("wl-copy") then
        return "wl-copy"
    elseif command_exists("pbcopy") then
        return "pbcopy"
    else
        mp.msg.error("No supported clipboard command found")
        return false
    end
end

local function divmod(a, b)
    return a / b, a % b
end

local function set_clipboard(text)
    if platform == WINDOWS then
        mp.commandv("run", "powershell", "set-clipboard", text)
        return true
    elseif (platform == UNIX and clipboard_cmd) then
        local pipe = io.popen(clipboard_cmd, "w")
        pipe:write(text)
        pipe:close()
        return true
    else
        mp.msg.error("Set_clipboard error")
        return false
    end
end

local function copyTime()
    local time_pos = mp.get_property_number("time-pos")
    local minutes, remainder = divmod(time_pos, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)
    local milliseconds = math.floor((remainder - seconds) * 1000)
    local time = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
    if set_clipboard(time) then
        mp.osd_message(string.format("Copied to Clipboard: %s", time))
    else
        mp.osd_message("Failed to copy time to clipboard")
    end
end


platform = platform_type()
if platform == UNIX then
    clipboard_cmd = get_clipboard_cmd()
end

mp.add_key_binding("Ctrl+c", "copyTime", copyTime)
