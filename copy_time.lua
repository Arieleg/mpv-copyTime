require 'mp'
require 'mp.msg'

-- Copy the current time of the video to clipboard.


local function platform_type()
    -- based on https://stackoverflow.com/a/30960054
    -- cannot distinguish between linux and MacOS reliably
    local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
    if BinaryFormat == "dll" then
        return "windows"
    else
        return "unix"
    end
end

local function command_exists(cmd)
    local pipe = io.popen("type " .. cmd .. " > /dev/null 2> /dev/null; printf \"$?\"", "r")
    return pipe:read() == "0"
end

local function divmod(a, b)
    return a / b, a % b
end


local function set_clipboard(text)
    local platform = platform_type()

    if platform == "windows" then
        mp.commandv("run", "powershell", "set-clipboard", text)

    elseif platform == "unix" then
        if command_exists("xclip") then
            -- linux + X11
            local pipe = io.popen("xclip -silent -in -selection clipboard", "w")
            pipe:write(text)
            pipe:close()

        elseif command_exists("pbcopy") then
            -- MacOS
            local pipe = io.popen("pbcopy", "w")
            pipe:write(text)
            pipe:close()

        else
            mp.msg.error("no supported clipboard command found")
        end
    else
        mp.msg.error("unknown platform " .. platform)
    end
end

local function copyTime()
    local time_pos = mp.get_property_number("time-pos")
    local minutes, remainder = divmod(time_pos, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)
    local milliseconds = math.floor((remainder - seconds) * 1000)
    local time = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)

    mp.osd_message(string.format("Copied to Clipboard: %s", time))
    set_clipboard(time)
end

mp.add_key_binding("Ctrl+c", "copyTime", copyTime)

