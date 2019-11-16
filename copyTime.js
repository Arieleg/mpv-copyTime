function setClipboard(text) {
    mp.commandv("run", "powershell", "set-clipboard", text);
}

function formatTime(time) {
    var r = "" + time;
    while (r.length < 2) {
        r = "0" + r;
    }
    return r;
}

function copyTime() {
    var time_pos = mp.get_property_number("time-pos");
    var time_seg = time_pos % 60;
    time_pos -= time_seg;
    var time_hours = Math.floor(time_pos / 3600);
    time_pos -= time_hours * 3600;
    var time_minutes = time_pos / 60;
    var time_ms = time_seg - Math.floor(time_seg);
    time_seg -= time_ms
    var time = formatTime(time_hours) + ":" + formatTime(time_minutes) + ":" + formatTime(time_seg) + "." + time_ms.toFixed(9).toString().split(".")[1];
    setClipboard(time)
    mp.osd_message("Copied to Clipboard: " + time);    
}

mp.add_key_binding("Ctrl+Alt+c", "copyTime", copyTime);
