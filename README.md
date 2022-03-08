# mpv-copyTime
Copy the current time of the video to clipboard.

Get the current time of the video and copy it to the clipboard with the format HH:MM:SS.MS, where MS (milliseconds) is 3 digits.

By default, the script is bound to "Ctrl + c"

External commands are used to access the clipboard:
- `Powershell` is used on Windows
- `xclip` is used on Linux + X11
- `wl-copy` or `xclip` is used on Linux + Wayland
- `pbcopy` is used on MacOS

# Installation

Put the `copy_time.lua` script in your scripts folder
- usually `"%APPDATA%\mpv\scripts"` on Windows
- usually `"~/.config/mpv/scripts/"` on Linux and Mac

# Screenshot
![ss1](https://user-images.githubusercontent.com/40000640/111867156-02f68a00-8951-11eb-84a8-c78616c68aa3.PNG)
