percent=$(pmset -g batt | grep -Eo "\d+%" | tr -d '%')
low_power=$(pmset -g | grep lowpowermode | awk '{print substr($0, length, 1)}')

echo "Battery Percentage: $percent"
echo "Low Power Mode: $low_power"

if [ "$percent" -lt 20 ] && [ "$low_power" = "0" ]; then
    echo 'Turning on low power mode.'
    osascript -e 'tell application "Shortcuts Events" to run shortcut "Toggle Low Power"'
elif [ "$percent" -gt 30 ] && [ "$low_power" = "1" ]; then 
    echo 'Turning off low power mode.'
    osascript -e 'tell application "Shortcuts Events" to run shortcut "Toggle Low Power"'
fi

exit 0
