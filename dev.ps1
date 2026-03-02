# ============================================================
#  DEBUG MODE: LIM TECH LABS - System Deployment
# ============================================================

Write-Host "DEBUG: Script Started..." -ForegroundColor Yellow

# 1. Force Admin Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "DEBUG: Not Admin. Attempting to elevate..." -ForegroundColor Red
    
    # We use a slightly different elevation command to catch errors
    $RemoteCommand = "iex (irm 'https://activate.limtechlabs.top')"
    try {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command $RemoteCommand" -Verb RunAs
    } catch {
        Write-Host "DEBUG: Elevation failed: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to exit"
    }
    exit
}

Write-Host "DEBUG: Admin Rights Confirmed!" -ForegroundColor Green

# 2. Setup Interface
$Host.UI.RawUI.WindowTitle = "Lim Tech Labs - Deployment Tool (Admin)"
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
Write-Host "DEBUG: Loading Interface... Press Enter to continue" -ForegroundColor Gray
Read-Host # PAUSE 1

# 3. Fetch and Execute Massgrave
try {
    Write-Host "DEBUG: Attempting to fetch Massgrave..." -ForegroundColor Gray
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    Write-Host "DEBUG: Fetch successful. Running Massgrave now..." -ForegroundColor Green
    
    # Run the engine
    Invoke-Expression $MAS
} catch {
    Write-Host "DEBUG: ERROR during fetch/exec: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to see details before closing"
}

Write-Host "DEBUG: Script reached the end." -ForegroundColor Yellow
Read-Host "Final Pause - Press Enter to Close Window"
