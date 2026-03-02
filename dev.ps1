# ============================================================
#  LIM TECH LABS - System Deployment & License Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Force Admin Privileges (Bulletproof Method)
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
Write-Host ""
Write-Host "Initializing Lim Tech Labs Environment..." -ForegroundColor Gray
Write-Host "Status: Authenticated (Admin)" -ForegroundColor Green
Write-Host ""

# 3. Fetch and Execute Massgrave Engine
try {
    Write-Host "Connecting to Global Backend..." -ForegroundColor Gray
    # Using a direct variable to prevent the "fast exit"
    $MAS_CODE = Invoke-RestMethod -Uri "https://get.activated.win"
    Invoke-Expression $MAS_CODE
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor White
    Pause
}

# 4. Open Portfolio (Only runs AFTER you close the MAS menu)
Write-Host ""
Write-Host "Task Complete. Opening Lim Tech Labs Portfolio..." -ForegroundColor Cyan
Start-Process "https://limtechlabs.top"
