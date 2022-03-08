require 'mp'
require 'mp.msg'

-- Copy the current time of the video to clipboard.


local function platform_type()
    local utils = require 'mp.utils'
    local workdir = utils.to_string(mp.get_property_native("working-directory"))
    if string.find(workdir, "\\") then
        return "windows"
    else
        return "unix"
    end
end

local function command_exists(cmd)
    local pipe = io.popen("type " .. cmd .. " > /dev/null 2> /dev/null; printf \"$?\"", "r")
    exists = pipe:read() == "0"
    pipe:close()
    return exists
end

local function divmod(a, b)
    return a / b, a % b
end


local function set_clipboard(text)
    local platform = platform_type()

    if platform == "windows" then
        mp.commandv("run", "powershell", "set-clipboard", text)
        return true

    elseif platform == "unix" then
        -- copy using all available commands (e.g. on Linux, might have xclip AND wl-copy installed)
        local found_any = false

        if command_exists("xclip") then
            -- linux + X11
            local pipe = io.popen("xclip -silent -in -selection clipboard", "w")
            pipe:write(text)
            pipe:close()
            found_any = true
        end

        if command_exists("wl-copy") then
            -- linux + Wayland
            local pipe = io.popen("wl-copy", "w")
            pipe:write(text)
            pipe:close()
            found_any = true
        end

        if command_exists("pbcopy") then
            -- MacOS
            local pipe = io.popen("pbcopy", "w")
            pipe:write(text)
            pipe:close()
            found_any = true
        end

        if not found_any then
            mp.msg.error("No supported clipboard command found")
        end
        return found_any

    else
        mp.msg.error("Unknown platform " .. platform)
        return false
    end
end

local function copy_time()
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

mp.add_key_binding("Ctrl+c", "copy_time", copy_time)
