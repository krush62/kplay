```
#!/bin/bash

echo "Starting Gesture watch..."
pgrep -f gesture_detect.py > /dev/null || gesture_detect.py &

echo "Starting application"
pgrep -f flutter-pi > /dev/null || flutter-pi --release ~/kplay/flutter_assets/
exit_code=$?
if [ $exit_code -eq 2 ]; then
  echo "starting chromium with youtube"
  switch_to_chrome.sh "https://youtube.com"
elif [ $exit_code -eq 3 ]; then
  echo "starting chromium with youtube music"
  switch_to_chrome.sh "https://music.youtube.com"
else
  echo "finished application"
fi

exit 0
```