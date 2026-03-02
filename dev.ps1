# ============================================================
#  LIM TECH LABS - System Deployment & License Utility
#  Repository: limtechlabs.top
# ============================================================

# 1. Check for Administrator Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 2. Set Window Title and Clear Screen
$Host.UI.RawUI.WindowTitle = "Lim Tech Labs - Deployment Tool"
Clear-Host

# 3. Display Custom Header
$Header = @"
############################################################
#                                                          #
#                WELCOME TO LIM TECH LABS                  #
#           System Deployment & License Utility            #
#                                                          #
############################################################
"@

Write-Host $Header -ForegroundColor Cyan
Write-Host ""
Write-Host "Initializing Lim Tech Labs Environment..." -ForegroundColor Gray
Write-Host "Status: Authenticated (Admin)" -ForegroundColor Green
Write-Host ""

# 4. Short Pause for Branding Visibility
Start-Sleep -Seconds 2

# 5. Fetch and Execute the Massgrave Engine Live
try {
    Write-Host "Connecting to Global Activation Backend..." -ForegroundColor Gray
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    Invoke-Expression $MAS
}
catch {
    Write-Host "Error: Could not connect to the backend." -ForegroundColor Red
    Write-Host "Please check your internet connection." -ForegroundColor White
    Pause
}