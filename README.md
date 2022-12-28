# mpv-copyTime
Copy the current time of the video to clipboard.

Get the current time of the video and copy it to the clipboard with the format HH:MM:SS.MS, where MS (milliseconds) is 3 digits.

By default, the script is bound to "Ctrl + c"

# Installation

Put the script `copyTime.lua` in your scripts folder, usually in:
*  Windows: `"%APPDATA%\mpv\scripts"`.
*  Linux and Mac: `"~/.config/mpv/scripts/"`.

To work, the script needs:
* Windows: `Powershell`.
* Linux/X11: `xclip`.
* Linux/Wayland : `wl-clipboard`.
* MacOS: `pbcopy` (not tested). 

# Screenshot
![ss1](https://user-images.githubusercontent.com/40000640/111867156-02f68a00-8951-11eb-84a8-c78616c68aa3.PNG)
