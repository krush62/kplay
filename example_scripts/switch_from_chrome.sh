```
#!/bin/bash

# Killing chromium and vlc + flutter-pi (just in case)
pkill chromium
pkill flutter-pi
pkill vlc

# Waiting for 5 seconds
echo "Waiting for 5 seconds"
sleep 5

# Starting application
startup.sh
```