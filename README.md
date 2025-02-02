# ToggleLowPower
Automatically trigger a Siri Shortcut on macOS based on the battery state

## toggle_low_power.sh
This shell script does the actual process of invoking a Siri Shortcut based on the battery percentage and lower power state
- My shortcut is named `Toggle Low Power`
  - The shortcut itself turns low power on or off depending if it is already on or off
- The script currently invokes the shortcut if the battery state is <20% and low power is off or if the battery is >30% and low power is on
- The shortcut is invoked via `osascript` rather than `shortcuts run` (or `/usr/bin/shortcuts run`) because of permission issues when running from the LaunchDaemon

### Setup
1. Place the script where you want it. My choice was `/usr/local/bin`
2. Make sure the script is executable
```shell
chmod +x /path/to/your/script.sh
```
3. Grant root access to the script so the LaunchDaemon can execute it
```shell
sudo chown root:wheel /path/to/your/script.sh
sudo chmod 755 /path/to/your/script.sh
```

## com.me.ToggleLowPoswer.plist
This needs to be registered as a LaunchDaemon for macOS to schedule invocation of the `toggle_low_power.sh` script. 

### Setup
1. Set the `ProgramArguments` path to `/path/to/your/script.sh`
2. Adjust the `StartInterval` to how often it should run
    1. This is in seconds, so 300 is five minutes
3. Paste into `/Library/LaunchDaemons/`
4. Grant root access to the plist so the LaunchDaemon can bootstrap it
```shell
sudo chown root:wheel /Library/LaunchDaemons/yourfile.plist
```
5. Load the daemon
```shell
sudo launchctl bootstrap system /Library/LaunchDaemons/yourfile.plist
```

## Troubleshooting
- If the daemon isn't working correctly, try uncommenting the output and error log paths in the plist file
```xml
<key>StandardOutPath</key>
<string>/Users/your_user/Desktop/output.log</string>
<key>StandardErrorPath</key>
<string>/Users/your_user/Desktop/error.log</string>
```
- Any time you modify your plist file you must unload and reload the daemon
```shell
sudo launchctl bootout system /Library/LaunchDaemons/yourfile.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/yourfile.plist
```
- To check if the daemon is registered use
```shell
sudo launchctl list | grep <your.daemon.label>
```
- To view launchd logs use
```shell
log show --predicate 'process == "launchd"' --info --last 5m
```
- To view shortcuts logs use
```shell
log show --predicate 'eventMessage contains "shortcut"' --info --last 1m
```
