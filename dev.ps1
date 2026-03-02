# ============================================================
#  LIM TECH LABS - System Utility
#  Command: irm activate.limtechlabs.top | iex
# ============================================================

# 1. Auto-Elevate using your exact command
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm activate.limtechlabs.top | iex`"" -Verb RunAs
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
Write-Host "Initializing Backend... Please wait.`n" -ForegroundColor Gray

try {
    # 3. Download the RAW MAS code (Bypasses the HTML/PowerShell wrapper)
    $RawUrl = "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd"
    $MAS = Invoke-RestMethod -Uri $RawUrl
    
    # 4. Save to Public folder
    $FilePath = "$env:PUBLIC\LimTech_Engine.cmd"
    [System.IO.File]::WriteAllText($FilePath, $MAS)
    
    # 5. Execute natively and lock the window
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"`"$FilePath`" -el -qedit`"" -NoNewWindow -Wait
    
    # 6. Cleanup
    Remove-Item -Path $FilePath -Force -ErrorAction SilentlyContinue

} catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
