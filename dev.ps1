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
    
    # 4. Save to Public folder (Zero spaces, zero system folder blocks)
    $FilePath = "$env:PUBLIC\LimTech_Engine.cmd"
    [System.IO.File]::WriteAllText($FilePath, $MAS)
    
    # 5. FIX: Change working directory. 
    # System32 blocks temporary files. We move to the Public folder first.
    Set-Location -Path $env:PUBLIC

    # 6. Inject Bypass Variables so MAS stays in this window
    $env:mas_window_setup = "1"
    $env:params = "-el"
    
    # 7. FIX: Execute natively. 
    # By just calling the file directly with '&', PowerShell perfectly translates 
    # the path to CMD without breaking the quotes.
    & $FilePath -el
    
    # 8. Cleanup
    Set-Location -Path $env:USERPROFILE # Move out of Public before deleting
    Remove-Item -Path $FilePath -Force -ErrorAction SilentlyContinue

} catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
