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

# 3. Fetch with Progress Bar
try {
    Write-Host "Connecting to Global Backend... " -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
    Write-Host "Connected!" -ForegroundColor Green
    Write-Host ""

    # Simulated Download Bar for the Script
    for ($i = 1; $i -le 100; $i += 5) {
        Write-Progress -Activity "Downloading Lim Tech Labs Engine" -Status "$i% Complete" -PercentComplete $i
        Start-Sleep -Milliseconds 50
    }

    $MAS_CODE = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # Complete the Progress Bar
    Write-Progress -Activity "Downloading Lim Tech Labs Engine" -Completed
    
    # Execute Massgrave
    Invoke-Expression $MAS_CODE
} 
catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor White
    Pause
}

# 4. Final Countdown
Clear-Host
Write-Host $Header -ForegroundColor Cyan
Write-Host ""
Write-Host "Thank you for using this tool!" -ForegroundColor Yellow
Write-Host ""

$Seconds = 30
while ($Seconds -gt 0) {
    Write-Host "`rThis application will automatically close after $Seconds seconds... " -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
    $Seconds--
}

Write-Host "`rClosing now. Goodbye!                             " -ForegroundColor White
Start-Sleep -Seconds 1
exit
