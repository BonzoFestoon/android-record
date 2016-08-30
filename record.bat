@echo off
goto :Code
==============================================================================
RECORD.BAT

Usage:
Only the first parameter is used and should be an integer>=0
%1>0 will record video for that many number of seconds (mp4)
%1==0 will take a screenshot (png)

The file name created will be named based on the time the file is pulled
from the device.

Instructions:

1) Connect your device
2) In the console, type "adb devices" to make sure you can connect to the device
3) Enjoy!

==============================================================================
==============================================================================
:Code

adb devices
if %1==0 (
    adb shell screencap -p /sdcard/screen.png
    adb pull /sdcard/screen.png
    adb shell rm /sdcard/screen.png
    for /f "tokens=1-5 delims=:" %%d in ("%time%") do rename "screen.png" %%d-%%e-%%f.png
) else (
    adb shell screenrecord --time-limit %1 --bit-rate 6000000 /sdcard/demo.mp4
    adb pull /sdcard/demo.mp4
    adb shell rm /sdcard/demo.mp4
    for /f "tokens=1-5 delims=:" %%d in ("%time%") do rename "demo.mp4" %%d-%%e-%%f.mp4
)

goto :End

=============================================================================
==============================================================================

:: MORE NOTES:

:: If you want to disconnect from USB, you can connect ADB via wireless:
:: First, connect to USB as normal:
:: Get the WIFI ip address.  There are a couple ways to do this:

:: GET IP ADDRESS:
:: List the nics on the device. You can find the ip address for the wlan there.
adb shell netcfg

:: LISTEN ON A PORT:
:: Have the device listen on port 5555:
adb tcpip 5555

:: Disconnect the device from USB:
:: Connect ADB to the device via the IP address:
adb connect <device-ip-address>

:: Confirm you are connected:
adb devices

:: If the adb connection is ever lost:
:: 1 - Make sure that your host is still connected to the same Wi-Fi network your Android device is.
:: 2 - Reconnect by executing the "adb connect" step again.
:: 3 - Or if that doesn't work, reset your adb host:
adb kill-server
:: and then start over from the beginning:

=============================================================================
==============================================================================

:End
