@echo off
:menu
cls
echo -------------------------------------
echo Advanced Network Diagnostic Tool
echo -------------------------------------
echo 1. Ping Test               - Check connectivity to a host by sending ICMP packets.
echo 2. Traceroute              - Trace the path packets take to a host, showing delays and hops.
echo 3. IP Configuration        - Display IP settings for network adapters on the device.
echo 4. DNS Lookup              - Query DNS servers to resolve a domain to an IP address.
echo 5. Network Interfaces      - Show the status of network interfaces (enabled/disabled).
echo 6. Bandwidth Test          - Simulate a bandwidth test to estimate download speed.
echo 7. Network Reset           - Reset network settings, including TCP/IP stack and DNS cache.
echo 8. Port Scanning           - Scan a range of ports on a host to check availability.
echo 9. Firewall Status Check    - Display the current status of the firewall (enabled/disabled).
echo 10. Wi-Fi Signal Strength Test - Check the strength of the Wi-Fi signal for troubleshooting.
echo 11. ARP Table Display       - View the ARP table, listing known devices on the network.
echo 12. Packet Capture         - Capture network packets for a short duration for analysis.
echo 13. MTU Test               - Test the Maximum Transmission Unit size for packet handling.
echo 14. Latency and Jitter Test - Test latency and jitter by pinging a host multiple times.
echo 15. External IP Check      - Display the external IP address assigned by the ISP.
echo 16. Exit                   - Exit the diagnostic tool.
echo.
set /p choice="Enter your choice (1-16): "
if "%choice%"=="1" goto pingtest
if "%choice%"=="2" goto traceroute
if "%choice%"=="3" goto ipconfig
if "%choice%"=="4" goto dnslookup
if "%choice%"=="5" goto netinterfaces
if "%choice%"=="6" goto bandwidthtest
if "%choice%"=="7" goto networkreset
if "%choice%"=="8" goto portscan
if "%choice%"=="9" goto firewallcheck
if "%choice%"=="10" goto wifisignal
if "%choice%"=="11" goto arptable
if "%choice%"=="12" goto packetcapture
if "%choice%"=="13" goto mtutest
if "%choice%"=="14" goto latencytest
if "%choice%"=="15" goto externalip
if "%choice%"=="16" exit
goto menu

:pingtest
cls
set /p hostname="Enter hostname or IP to ping: "
ping %hostname%
set result=%errorlevel%
echo.
if %result%==0 (
    echo Ping test successful. The host is reachable.
    echo Recommendation: No further action required.
) else (
    echo Ping test failed. The host is not reachable.
    echo Recommendation: Check network connection or verify the hostname/IP.
)
pause
goto menu

:traceroute
cls
set /p hostname="Enter hostname or IP to trace: "
tracert %hostname%
echo.
echo Summary: Traceroute completed. Check for delays or high hops.
echo Recommendation: If there is a high delay, consider contacting your ISP.
pause
goto menu

:ipconfig
cls
ipconfig /all
echo.
echo Summary: IP configuration displayed.
echo Recommendation: Verify IP settings, especially DNS and gateway addresses.
pause
goto menu

:dnslookup
cls
set /p domain="Enter domain name to lookup: "
nslookup %domain%
echo.
echo Summary: DNS lookup completed.
echo Recommendation: Verify DNS server settings if issues occur.
pause
goto menu

:netinterfaces
cls
netsh interface show interface
echo.
echo Summary: Network interfaces displayed.
echo Recommendation: Check that all required interfaces are enabled.
pause
goto menu

:bandwidthtest
cls
echo Simulating bandwidth test (downloading test file)...
bitsadmin /transfer testdownload /download /priority high http://ipv4.download.thinkbroadband.com/10MB.zip %temp%\10MB.zip
echo Test complete.
echo Summary: Bandwidth test completed. Check download speed.
echo Recommendation: If speed is slow, check with your ISP or network configuration.
pause
goto menu

:networkreset
cls
echo Resetting TCP/IP stack and DNS cache...
netsh int ip reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns
echo Network reset complete.
echo Summary: Network settings reset.
echo Recommendation: Restart your computer if connectivity issues persist.
pause
goto menu

:portscan
cls
set /p hostname="Enter hostname or IP to scan ports: "
set /p startport="Enter starting port: "
set /p endport="Enter ending port: "
for /l %%a in (%startport%,1,%endport%) do (
    echo Scanning port %%a...
    powershell Test-NetConnection %hostname% -Port %%a
)
echo.
echo Summary: Port scan completed.
echo Recommendation: Check if any necessary ports are closed.
pause
goto menu

:firewallcheck
cls
netsh advfirewall show allprofiles
echo.
echo Summary: Firewall status displayed.
echo Recommendation: Ensure firewall is enabled and configured properly.
pause
goto menu

:wifisignal
cls
netsh wlan show interfaces
echo.
echo Summary: Wi-Fi signal strength displayed.
echo Recommendation: If signal is weak, consider relocating closer to the router.
pause
goto menu

:arptable
cls
arp -a
echo.
echo Summary: ARP table displayed.
echo Recommendation: Verify ARP entries for unknown devices.
pause
goto menu

:packetcapture
cls
echo Starting packet capture...
netsh trace start capture=yes
echo Capturing for 10 seconds...
timeout /t 10 >nul
netsh trace stop
echo Capture complete.
echo Summary: Packet capture completed.
echo Recommendation: Analyze captured packets for potential issues.
pause
goto menu

:mtutest
cls
set /p hostname="Enter hostname to test MTU: "
ping -f -l 1472 %hostname%
echo.
echo Summary: MTU test completed.
echo Recommendation: Adjust MTU settings if packet loss occurs.
pause
goto menu

:latencytest
cls
set /p hostname="Enter hostname or IP for latency test: "
for /l %%i in (1,1,10) do ping %hostname% -n 1
echo.
echo Summary: Latency test completed.
echo Recommendation: Check for high latency, which may affect performance.
pause
goto menu

:externalip
cls
echo Your external IP address is:
nslookup myip.opendns.com resolver1.opendns.com
echo.
echo Summary: External IP address retrieved.
echo Recommendation: No further action required unless verifying IP location.
pause
goto menu
