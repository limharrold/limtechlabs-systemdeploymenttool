# ============================================================
#  LIM TECH LABS - Integrated System Utility
#  Host: activate.limtechlabs.top
# ============================================================

# 1. Stealth Elevation
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

# 3. Fetch and Execute (Using the "Safe Injection" Method)
try {
    $MAS_RAW = Invoke-RestMethod -Uri "https://get.activated.win"
    
    $TempFile = Join-Path $env:TEMP "LimTech_Engine.cmd"
    
    # We add the "Stop Window Spawning" variables to the very top of the file
    $Prefix = "@echo off`r`nset mas_window_setup=1`r`nset params=-el`r`nset \"_args=-el\"`r`n"
    $FinalCode = $Prefix + $MAS_RAW
    
    Set-Content -Path $TempFile -Value $FinalCode
    
    # --- THE FIX ---
    # We use 'cmd /c' to run it. If it crashes, it will return to PowerShell 
    # where we have a 'Pause' waiting for you.
    & $env:ComSpec /c "`"$TempFile`" -el"
    
    # Final Pause so you can see if there was an error message
    Write-Host "`nLim Tech Labs: Process finished." -ForegroundColor Yellow
    Read-Host "Press Enter to close this window"

    # Cleanup
    Remove-Item $TempFile -ErrorAction SilentlyContinue
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Read-Host "Press Enter to exit"
}
