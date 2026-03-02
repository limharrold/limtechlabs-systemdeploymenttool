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

# 3. Fetch, Strip, and Execute
try {
    $MAS_RAW = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # --- THE ULTIMATE FIX ---
    # We find the part where Massgrave starts its window management and CUT IT OUT.
    # We look for the ':main' label or the end of the elevation block.
    
    # We split the script into lines
    $Lines = $MAS_RAW -split "`r`n"
    $CleanLines = @()
    $Skip = $true
    
    foreach ($Line in $Lines) {
        # We search for the start of the actual Menu logic
        if ($Line -like "*:mainmenu*" -or $Line -like "*:main*") { $Skip = $false }
        if (-not $Skip) { $CleanLines += $Line }
    }

    $TempFile = Join-Path $env:TEMP "LimTech_Engine.cmd"
    
    # We manually add the required setup variables back in since we cut them out
    $FinalCode = "@echo off`r`nset mas_window_setup=1`r`nset params=-el`r`n" + ($CleanLines -join "`r`n")
    Set-Content -Path $TempFile -Value $FinalCode
    
    # Run the cleaned engine internally
    & $env:ComSpec /c "`"$TempFile`" -el"
    
    # Cleanup
    Remove-Item $TempFile -ErrorAction SilentlyContinue
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Pause
}
