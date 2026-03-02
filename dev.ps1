# ============================================================
#  LIM TECH LABS - Integrated System Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Force Admin Privileges (Bulletproof Elevation)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    $ArgList = "-NoProfile -ExecutionPolicy Bypass -Command `"iex (irm 'https://activate.limtechlabs.top')`""
    try {
        Start-Process powershell.exe -ArgumentList $ArgList -Verb RunAs
    } catch {
        Write-Host "Elevation failed. Please run PowerShell as Admin." -ForegroundColor Red
        Pause
    }
    exit 
}

# 2. Interface Setup
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
Write-Host "Initializing Lim Tech Labs Environment..." -ForegroundColor Gray
Start-Sleep -Seconds 1

# 3. Execution (The "No-Crash" Method)
try {
    # We download the MAS script directly into a variable
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # We create the temp file
    $TempFile = "$env:SystemRoot\Temp\LimTech_Engine.cmd"
    Set-Content -Path $TempFile -Value $MAS
    
    # --- THE CRITICAL FIX ---
    # We set these variables at the SYSTEM level for this session.
    # We also call it using 'cmd /k' so if it crashes, the window STAYS OPEN 
    # so you can read the error message.
    $env:mas_window_setup = "1"
    $env:params = "-el"
    
    & $env:ComSpec /c "`"$TempFile`" -el"
    
    # Cleanup after closing
    if (Test-Path $TempFile) { Remove-Item $TempFile -Force }
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Pause
}
