# ============================================================
#  LIM TECH LABS - Integrated System Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Stealth Elevation (Powershell Side)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
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
Write-Host "Initializing Lim Tech Labs Environment..." -ForegroundColor Gray
Start-Sleep -Seconds 2

# 3. Fetch and Execute Massgrave (Internal Force)
try {
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # We save to a temp file
    $TempFile = Join-Path $env:TEMP "LimTech_Engine.cmd"
    Set-Content -Path $TempFile -Value $MAS
    
    # THE FIX: We add "-el" as an argument. 
    # This tells the MAS script to skip its own window-spawning logic.
    & $env:ComSpec /c "`"$TempFile`" -el"
    
    # Cleanup
    Remove-Item $TempFile -ErrorAction SilentlyContinue
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Pause
}
