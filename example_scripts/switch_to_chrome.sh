```
#!/bin/bash

URL="$1"

echo "Killing flutter-pi..."
pkill flutter-pi

echo "Killing vlc..."
pkill vlc


# Check if a URL parameter was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

URL="$1"

echo "Waiting for 4 seconds..."
sleep 4

# Start Chromium in kiosk mode with the provided URL
startx /usr/bin/chromium --no-sandbox --kiosk "$URL" --start-fullscreen --window-position=0,0 --window-size=1024,600 --noerrdialogs --disable-infobars --disable-session-crashed-bubble
```