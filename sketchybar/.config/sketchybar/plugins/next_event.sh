#!/bin/sh

next_event=$(osascript 2>/dev/null <<'APPLESCRIPT'
set nowDate to current date
set cutoffDate to nowDate + (90 * minutes)
set nextStart to missing value
set nextTitle to ""

tell application "Calendar"
  repeat with cal in calendars
    try
      set upcomingEvents to every event of cal whose start date is greater than or equal to nowDate and start date is less than or equal to cutoffDate and allday event is false
      repeat with calendarEvent in upcomingEvents
        set eventStart to start date of calendarEvent
        if nextStart is missing value or eventStart < nextStart then
          set nextStart to eventStart
          set nextTitle to summary of calendarEvent
        end if
      end repeat
    end try
  end repeat
end tell

if nextStart is missing value then return ""
set eventHour to text -2 thru -1 of ("0" & (hours of nextStart))
set eventMinute to text -2 thru -1 of ("0" & (minutes of nextStart))
return eventHour & ":" & eventMinute & " " & nextTitle
APPLESCRIPT
)

if [ -n "$next_event" ]; then
  sketchybar --set "$NAME" drawing=on icon="󰃭" label="$next_event"
else
  sketchybar --set "$NAME" drawing=off
fi
