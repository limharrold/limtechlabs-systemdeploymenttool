# ============================================================
#  LIM TECH LABS - System Utility (Stable Build)
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Improved Elevation logic
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
    
    # Save to a fixed path (System Temp)
    $FilePath = "$env:SystemRoot\Temp\MAS_Internal.cmd"
    Set-Content -Path $FilePath -Value $MAS
    
    # Inject variables directly into the environment for this session
    $env:mas_window_setup = "1"
    $env:params = "-el"
    $env:_args = "-el"

    # RUN COMMAND: We use /k so if the script crashes, the window STAYS OPEN.
    # This will let you read the error message if it fails.
    cmd.exe /k "`"$FilePath`" -el"

    # Cleanup (runs after you manually close the CMD part)
    if (Test-Path $FilePath) { Remove-Item $FilePath -Force }
}
catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
