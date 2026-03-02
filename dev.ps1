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
Write-Host "Initializing Environment..." -ForegroundColor Gray
Start-Sleep -Seconds 2

# 3. Fetch, Modify, and Execute
try {
    $MAS_RAW = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # --- THE FIX: STRIP WINDOW MANAGEMENT ---
    # We remove the lines that force a new window size or title
    # This keeps the script trapped inside OUR window.
    $MAS_CLEAN = $MAS_RAW -replace 'mode con.*', '' -replace 'title .*', '' -replace 'color .*', ''
    
    $TempFile = Join-Path $env:TEMP "LimTech_Engine.cmd"
    
    # We force the MAS script to skip its own elevation check
    $FinalCode = "@set mas_window_setup=1`r`n@set params=-el`r`n" + $MAS_CLEAN
    Set-Content -Path $TempFile -Value $FinalCode
    
    # Execute internally
    & $env:ComSpec /c "`"$TempFile`" -el"
    
    # Cleanup
    Remove-Item $TempFile -ErrorAction SilentlyContinue
} catch {
    Write-Host "Error: Connection to backend failed." -ForegroundColor Red
    Pause
}
