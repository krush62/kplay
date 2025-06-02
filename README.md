# kplay - A simple jukebox for the RaspberryPi
- flutter as frontend
- vlc as backend

## Setup

### 🧰 Hardware Installation
- *[Optional]* Install cooling solution
- Connect Display to RasPi via DSI
  - see [Waveshare](https://www.waveshare.com/wiki/5inch_DSI_LCD_(C))
- Install [HiFiBerry Digi2 Pro](https://www.hifiberry.com/shop/boards/digi2-pro/) as GPIO hat
- *[Optional]* Connect Power Button to pins 5 and 6 of the GPIO (GPIO 3 and GND)

### 💾 Image Installation
Raspberry Pi Imager
- use Raspberry Pi OS Lite (64-bit)
- edit config with username, keyboard layout, wifi and enable ssh
- after writing image, open config.txt:
  - add to the end: `dtoverlay=vc4-kms-dsi-waveshare-panel,7_0_inchC`
  - add to the end: `dtoverlay=hifiberry-digi-pro`
  - Disable all audio cards (except hifiberry):
  - change `dtparam=audio=on` to `dtparam=audio=off`
  - change `dtoverlay=vc4-kms-v3d` to `dtoverlay=vc4-kms-v3d,noaudio`


### ⚙ System Setup
- run `sudo raspi-config`
  - Auto Login: System Options -> Auto Login
- Allow 3D acceleration: `sudo usermod -a -G render [USER_NAME]`


### 🍓 Install FlutterPi
- Install necessary libraries: `sudo apt install git cmake libgl1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev libdrm-dev libgbm-dev ttf-mscorefonts-installer fontconfig libsystemd-dev libinput-dev libudev-dev  libxkbcommon-dev`
- Update System Fonts: `sudo fc-cache`
- Clone FlutterPi: `git clone --recursive https://github.com/ardera/flutter-pi`
- Compile and Install FlutterPi:
  - Switch to flutter-pi directory: `cd flutter-pi`
  - Create build directory and switch to it: `mkdir build && cd build`
  - Build FlutterPi: `cmake ..`
  - Compile FlutterPi: `make` ``make -j`nproc` ``
  - Install FlutterPi: `sudo make install`

### ▶ Install kplay
- install jq for download parsing: `sudo apt-get install jq`
- Create kplay directory: `mkdir ~/kplay`
- Switch to directory: `cd ~/kplay`
- download latest release archive: `curl -s https://api.github.com/repos/krush62/kplay/releases/latest | jq -r '(.assets[].browser_download_url | select(. | contains("tar.gz")))' | xargs wget {} -O kplay_release.tar.gz`
- extract archive: `tar -xzvf kplay_release.tar.gz`
- delete archive `rm kplay_release.tar.gz`

### ⚙ Install Additional Tools for kplay
| Library  | Purpose                                             |
|----------|-----------------------------------------------------|
| VLC      | audio backend                                       |
| ExifTool | retrieving audio metadata                           |
| FFMpeg   | retrieve album art                                  |
| Sqlite   | library database                                    |
| Chromium | displaying YouTube and YT-Music                     |
| XOrg     | display server for showing chromium                 |
| XTerm    | needed by startx/xinit to start with relative paths |
- Install: `sudo apt-get install vlc exiftool ffmpeg libsqlite3-dev chromium xorg xterm`

### ⚙ Set up Scripts
- Create bin directory in home: `mkdir ~/bin`
#### Gesture Detection for exiting Chrome
- Install required python package: `sudo apt install python3-evdev`
- Find touchscreen name: `python3 -m evdev.evtest`
- copy [gesture_detect.py](example_scripts/gesture_detect.py) to ~/bin, `chmod +x ~/bin/gesture_detect.py`
- check if the touchscreen name in script is the one detected above
#### Switch from Chrome to Application
- copy [switch_from_chrome.sh](example_scripts/switch_from_chrome.sh) to ~/bin, `chmod +x ~/bin/switch_from_chrome.sh`
#### Switch from Application to Chrome
- copy [switch_to_chrome.sh](example_scripts/switch_to_chrome.sh) to ~/bin, `chmod +x ~/bin/switch_to_chrome.sh`
#### Startup
- copy [startup.sh](example_scripts/startup.sh) to ~/bin, `chmod +x ~/bin/startup.sh`
#### Configure Autostart
- export bin path
  - Add this to the end of ~/.bashrc: `export PATH="$HOME/bin:$PATH"`
- copy [bash_profile](example_scripts/bash_profile) as `.bash_profile` to ~
- *[Optional]* remove not-used profile: `rm ~/.profile` (.bash_profile has exclusive priority)
- Reboot: `sudo reboot now`

## Build
### Build on Linux Machine
- Prepare for FlutterPi (one time only)
- Install SDK: [Flutter Documentation](https://docs.flutter.dev/get-started/install/linux/desktop) to ~/flutter
- Export paths:
  - `export PATH="$PATH:~/.pub-cache/bin"`
  - `export PATH="$PATH:~/flutter/bin"` (if that's the flutter location)
- Install/Activate flutterpi_tool: `flutter pub global activate flutterpi_tool`
- Clone FlutterPi: `git clone --recursive https://github.com/krush62/kplay`
- build application normally and for FlutterPi:
  - `cd kplay` (project folder)
  - `flutter build linux`
  - `flutterpi_tool build --arch=arm64 --cpu=pi4 --release`
- copy bundle to target (Raspberry Pi):
  - `scp -r build/flutter_assets/ [USER_NAME]@[RASPI_NAME]:/home/[USER_NAME]/kplay`
  - *[Optional]* copy music data to target (from Windows/Linux)
  - `scp -r "/path/to/music/folder" [USER_NAME]@[RASPI_NAME]:/home/[USER_NAME]/Music` (or any other directory)