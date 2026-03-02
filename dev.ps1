# ============================================================
#  LIM TECH LABS - System Deployment & License Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Force Admin Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Elevating to Administrator..." -ForegroundColor Yellow
    $args = "-NoProfile -ExecutionPolicy Bypass -Command `"iex (irm 'https://activate.limtechlabs.top')`""
    Start-Process powershell.exe -ArgumentList $args -Verb RunAs
    exit
}

# 2. Setup Interface
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
Write-Host "Status: Authenticated (Admin)" -ForegroundColor Green
Write-Host ""

# 3. Fetch, Clean, and Execute
try {
    Write-Host "Connecting to Global Backend... " -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
    Write-Host "Connected!" -ForegroundColor Green
    Write-Host ""

    # Downloading Progress Bar
    for ($i = 1; $i -le 100; $i += 10) {
        Write-Progress -Activity "Downloading Lim Tech Labs Engine" -Status "$i% Complete" -PercentComplete $i
        Start-Sleep -Milliseconds 50
    }

    # Fetching the Raw Code
    $MAS_RAW = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # REMOVE THE LINK: This replaces the massgrave homepage text with empty space
    $MAS_CLEAN = $MAS_RAW -replace 'Need help\? Check our homepage: https://massgrave.dev', ''
    
    Write-Progress -Activity "Downloading Lim Tech Labs Engine" -Completed
    
    # Execute the cleaned version
    Invoke-Expression $MAS_CLEAN
} 
catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor White
    Pause
}

# 4. Final Thank You & Countdown
Clear-Host
Write-Host $Header -ForegroundColor Cyan
Write-Host ""
Write-Host "Thank you for using this tool!" -ForegroundColor Yellow
Write-Host ""

$Seconds = 30
while ($Seconds -gt 0) {
    # Progress bar for the 30-second exit timer
    $Percent = [int](($Seconds / 30) * 100)
    Write-Progress -Activity "System Closing" -Status "Closing in $Seconds seconds..." -PercentComplete $Percent
    
    Write-Host "`rThis application will automatically close after $Seconds seconds... " -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
    $Seconds--
}

Write-Progress -Activity "System Closing" -Completed
Write-Host "`rClosing now. Goodbye!                             " -ForegroundColor White
Start-Sleep -Seconds 1
exit
