# ============================================================
#  LIM TECH LABS - System Deployment & License Utility
# ============================================================

# 1. Force Admin Privileges (Fixed for Remote/URL Execution)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    
    # This command tells the new Admin window to go back to your URL and run it again
    $RemoteCommand = "iex (irm 'https://activate.limtechlabs.top')"
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command $RemoteCommand" -Verb RunAs
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
Write-Host "Initializing Lim Tech Labs Environment..." -ForegroundColor Gray
Write-Host "Status: Authenticated (Admin)" -ForegroundColor Green
Start-Sleep -Seconds 2

# 3. Fetch and Execute Massgrave Engine
try {
    Write-Host "Connecting to Global Backend..." -ForegroundColor Gray
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    Invoke-Expression $MAS
} catch {
    Write-Host "Connection failed. Please check internet access." -ForegroundColor Red
    Pause
}

# 4. Open Portfolio (Only opens after MAS is closed)
Write-Host "Task Complete" -ForegroundColor Cyan
