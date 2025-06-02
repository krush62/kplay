```
#!/usr/bin/env python3
from evdev import InputDevice, list_devices, ecodes
import subprocess
import time

# Replace with your actual touchscreen input device
TOUCHSCREEN_NAME = "10-0014 Goodix Capacitive TouchScreen"

# Screen resolution — adjust as needed
SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 600

# Edge threshold (in pixels) to detect edge swipes
EDGE_THRESHOLD = 50

# Time and distance limits for swipe detection
MAX_DURATION = 1.0  # seconds
MIN_DISTANCE = 200  # pixels

# State
x_start = x_end = 0
y_start = y_end = 0
start_time = 0
in_touch = False

def find_touchscreen_device(name):
    devices = [InputDevice(path) for path in list_devices()]
    for device in devices:
        if device.name == name:
            return device
    return None

dev = find_touchscreen_device(TOUCHSCREEN_NAME)
if dev is None:
    print(f"Touchscreen device '{TOUCHSCREEN_NAME}' not found!")
    exit(1)

print(f"Using touchscreen device: {dev.path} - {dev.name}")

for event in dev.read_loop():
    if event.type == ecodes.EV_ABS:
        if event.code == ecodes.ABS_MT_POSITION_X:
            x = event.value
        elif event.code == ecodes.ABS_MT_POSITION_Y:
            y = event.value

    elif event.type == ecodes.EV_KEY and event.code == ecodes.BTN_TOUCH:
        if event.value == 1:  # Touch down
            x_start = x_end = x
            y_start = y_end = y
            start_time = time.time()
            in_touch = True
        elif event.value == 0 and in_touch:  # Touch up
            x_end = x
            y_end = y
            duration = time.time() - start_time

            # Check if swipe starts from left/right edge and moves inward
            is_swipe = (
                duration < MAX_DURATION and
                abs(x_end - x_start) > MIN_DISTANCE and
                y_start < SCREEN_HEIGHT * 0.9 and y_start > SCREEN_HEIGHT * 0.1  # avoid accidental bottom/top taps
            )

            from_left = x_start < EDGE_THRESHOLD and x_end > x_start
            from_right = x_start > SCREEN_WIDTH - EDGE_THRESHOLD and x_end < x_start

            if is_swipe and (from_left or from_right):
                print("Edge swipe detected — exiting Chromium...")
                subprocess.call(["switch_from_chrome.sh"])

            in_touch = False
```