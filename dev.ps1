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
    
    # FIX: Save to Public folder to completely avoid spaces in the path
    $FilePath = "$env:PUBLIC\LimTech_Engine.cmd"
    Set-Content -Path $FilePath -Value $MAS
    
    # Inject variables to bypass MAS self-elevation and window management
    $env:mas_window_setup = "1"
    $env:params = "-el"
    $env:_args = "-el"

    # FIX: Use Start-Process with -NoNewWindow to safely parse paths and lock the UI
    Start-Process -FilePath "$env:ComSpec" -ArgumentList "/c `"`"$FilePath`" -el`"" -NoNewWindow -Wait

    # Cleanup after you close the menu
    if (Test-Path $FilePath) { Remove-Item $FilePath -Force }
}
catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
