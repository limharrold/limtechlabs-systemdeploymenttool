# ============================================================
#  LIM TECH LABS - System Deployment & License Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Improved Admin Check & Auto-Elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Elevating to Administrator for Lim Tech Labs..." -ForegroundColor Yellow
    
    # This specifically tells the new window to run the URL again
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"iex (irm 'https://activate.limtechlabs.top')`"" -Verb RunAs
    exit
}

# 2. Interface Setup (Only runs in the Admin window)
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
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    Invoke-Expression $MAS
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Pause
}

# 4. Post-Execution (Portfolio Launch)
Write-Host "`nTask Complete. Opening Lim Tech Labs Portfolio..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Start-Process "https://limtechlabs.top"
