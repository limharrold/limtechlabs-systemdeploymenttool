# ============================================================
#  LIM TECH LABS - Integrated System Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Improved Admin Check & Stealth Elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Launch Admin version and kill the current non-admin one immediately
    $ArgList = "-NoProfile -ExecutionPolicy Bypass -Command `"iex (irm 'https://activate.limtechlabs.top')`""
    Start-Process powershell.exe -ArgumentList $ArgList -Verb RunAs
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
Write-Host "Initializing Environment..." -ForegroundColor Gray
Start-Sleep -Seconds 2

# 3. Fetch and Execute Massgrave (Forcing it to stay in this window)
try {
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # We save the script to a temporary file and run it via CMD /C
    # This prevents it from opening a new separate window
    $TempFile = Join-Path $env:TEMP "LimTech_Engine.cmd"
    Set-Content -Path $TempFile -Value $MAS
    
    & $env:ComSpec /c $TempFile
    
    # Cleanup after closing
    Remove-Item $TempFile -ErrorAction SilentlyContinue
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Pause
}
