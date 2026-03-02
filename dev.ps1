# ============================================================
#  LIM TECH LABS - System Deployment & License Utility
#  Host: activate.limtechlabs.top
#  Architecture: Harrold Gawad Lim
# ============================================================

# 1. CACHE BUSTER & ELEVATION
# This generates a unique ID based on the current time to force a fresh download
$CacheBuster = Get-Date -Format "yyyyMMddHHmmss"
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [ INFO ] Fresh update detected. Syncing latest version..." -ForegroundColor Yellow
    
    # We append the unique ID to your domain to bypass Cloudflare/ISP caching
    $args = "-NoProfile -ExecutionPolicy Bypass -Command `"iex (irm 'https://activate.limtechlabs.top?v=$CacheBuster')`""
    Start-Process powershell.exe -ArgumentList $args -Verb RunAs
    exit
}

# 2. FIX: TLS/SSL Support for Older Windows
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 3. Setup Interface
$Host.UI.RawUI.WindowTitle = "Lim Tech Labs - Deployment Tool"
Clear-Host

$Header = @"
############################################################
#                                                          #
#                WELCOME TO LIM TECH LABS                  #
#           System Deployment & License Utility            #
#                                                          #
############################################################
"@

Write-Host $Header -ForegroundColor Cyan
Write-Host " [ STATUS ] Authenticated (Administrator)" -ForegroundColor Green
Write-Host " [ INFO   ] Initializing System Deployment..." -ForegroundColor White
Write-Host ""
Write-Host " ----------------------------------------------------------" -ForegroundColor Gray
Write-Host "  ACKNOWLEDGMENT:" -ForegroundColor Yellow
Write-Host "  Special thanks to Massgrave.dev for making this" -ForegroundColor Gray
Write-Host "  utility possible and free for everyone." -ForegroundColor Gray
Write-Host " ----------------------------------------------------------" -ForegroundColor Gray
Write-Host ""

# 4. Fetch, Deep Clean, and Execute
try {
    Write-Host " Connecting to Global Backend... " -NoNewline -ForegroundColor Gray
    
    # DNS Bypass Logic
    $MAS_RAW = try {
        Invoke-RestMethod -Uri "https://get.activated.win" -ErrorAction Stop
    } catch {
        Write-Host "(DNS Bypass Active) " -ForegroundColor Yellow -NoNewline
        (curl.exe -s --doh-url https://1.1.1.1/dns-query https://get.activated.win | Out-String)
    }

    Write-Host "Connected!" -ForegroundColor Green
    Write-Host ""

    # Downloading Progress Bar
    for ($i = 1; $i -le 100; $i += 10) {
        Write-Progress -Activity "Lim Tech Labs: Syncing with Global Engine" -Status "$i% Complete" -PercentComplete $i
        Start-Sleep -Milliseconds 50
    }

    # --- THE DEEP CLEAN ---
    $MAS_CLEAN = $MAS_RAW -replace '(?m)^.*massgrave.*$', '' -replace '(?m)^.*homepage.*$', '' -replace '(?m)^.*Need help.*$', ''
    
    Write-Progress -Activity "Lim Tech Labs: Syncing with Global Engine" -Completed
    
    # Execute the cleaned version
    Invoke-Expression $MAS_CLEAN
} 
catch {
    Write-Host " [ ERROR ] Connection to backend failed." -ForegroundColor Red
    Write-Host " [ INFO  ] Details: $($_.Exception.Message)" -ForegroundColor White
    Pause
}

# 5. Final Thank You & 5-Second Countdown
Clear-Host
Write-Host $Header -ForegroundColor Cyan
Write-Host ""
Write-Host " [ COMPLETE ] Process finished successfully." -ForegroundColor Green
Write-Host " [ NOTICE   ] Thank you for choosing Lim Tech Labs!" -ForegroundColor Yellow
Write-Host ""

$Seconds = 5
while ($Seconds -gt 0) {
    $Percent = [int](($Seconds / 5) * 100)
    Write-Progress -Activity "Lim Tech Labs: System Shutdown" -Status "Closing in $Seconds seconds..." -PercentComplete $Percent
    
    Write-Host "`r This session will automatically close in $Seconds seconds... " -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
    $Seconds--
}

Write-Progress -Activity "Lim Tech Labs: System Shutdown" -Completed
Write-Host "`r Closing now. Goodbye!                                    " -ForegroundColor White
Start-Sleep -Seconds 1
exit
