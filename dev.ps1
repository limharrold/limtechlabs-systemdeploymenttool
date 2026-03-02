# ============================================================
#  LIM TECH LABS - System Deployment & License Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Improved Admin Check & Auto-Elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # This launches the Admin version and hides the current non-admin one
    $ArgList = "-NoProfile -ExecutionPolicy Bypass -Command `"iex (irm 'https://activate.limtechlabs.top')`""
    Start-Process powershell.exe -ArgumentList $ArgList -Verb RunAs
    exit 
}

# 2. Interface Setup (Only runs in the Administrator window)
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
Write-Host "Status: Authenticated (Administrator)" -ForegroundColor Green
Write-Host "Initializing Environment..." -ForegroundColor Gray
Start-Sleep -Seconds 2

# 3. Fetch and Execute Massgrave
try {
    # Fetching the engine live so it stays updated
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    Invoke-Expression $MAS
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Pause
}
