# Claude Pantheon V6 Installer (Windows PowerShell)
# Non-destructive: backs up everything before changes

$ErrorActionPreference = "Stop"
$PANTHEON_VERSION = "6.0.0"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$CarlDir = Join-Path $env:USERPROFILE ".carl"
$BackupDir = Join-Path $ClaudeDir "backups\pre-pantheon-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

$installed = 0
$skipped = 0

function Write-Banner {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "       CLAUDE PANTHEON V$PANTHEON_VERSION" -ForegroundColor Cyan
    Write-Host "  1,308 skills. 108 agents. One brain." -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Prereq {
    param($Name, $Command, $MinLabel)
    try {
        $ver = & $Command --version 2>&1 | Select-Object -First 1
        Write-Host "  [OK] $Name`: $ver" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [MISSING] $Name - please install $Name ($MinLabel+)" -ForegroundColor Red
        return $false
    }
}

function Install-PantheonFile {
    param($Source, $Dest, $Label)
    if (Test-Path $Dest) {
        Write-Host "  [SKIP] $Label (already exists)" -ForegroundColor Yellow
        $script:skipped++
    } else {
        $parent = Split-Path -Parent $Dest
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Copy-Item $Source $Dest
        Write-Host "  [INSTALL] $Label" -ForegroundColor Green
        $script:installed++
    }
}

Write-Banner

# --- Prerequisites ---
Write-Host "Checking prerequisites..." -ForegroundColor Cyan
$ok = $true
if (-not (Test-Prereq "Node.js" "node" "v18")) { $ok = $false }
if (-not (Test-Prereq "Python 3" "python3" "3.10")) { $ok = $false }
if (-not (Test-Prereq "Git" "git" "2.0")) { $ok = $false }
if (-not (Test-Prereq "npm" "npm" "8.0")) { $ok = $false }
Write-Host ""

if (-not $ok) {
    Write-Host "Missing prerequisites. Please install them and re-run." -ForegroundColor Red
    exit 1
}

# --- Confirmation ---
Write-Host "This will install Claude Pantheon V$PANTHEON_VERSION to ~/.claude/." -ForegroundColor Yellow
Write-Host "Your existing configuration will be backed up first."
$confirm = Read-Host "Continue? (y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Aborted."
    exit 0
}

# --- Backup ---
Write-Host "`nCreating backup..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
if (Test-Path "$ClaudeDir\settings.json") { Copy-Item "$ClaudeDir\settings.json" $BackupDir }
if (Test-Path "$ClaudeDir\CLAUDE.md") { Copy-Item "$ClaudeDir\CLAUDE.md" $BackupDir }
if (Test-Path "$ClaudeDir\agents") { Copy-Item "$ClaudeDir\agents" "$BackupDir\agents" -Recurse }
if (Test-Path "$ClaudeDir\commands") { Copy-Item "$ClaudeDir\commands" "$BackupDir\commands" -Recurse }
if (Test-Path "$ClaudeDir\hooks") { Copy-Item "$ClaudeDir\hooks" "$BackupDir\hooks" -Recurse }
if (Test-Path $CarlDir) { Copy-Item $CarlDir "$BackupDir\carl-backup" -Recurse }
Write-Host "  [OK] Backup saved to $BackupDir" -ForegroundColor Green

# --- Install Agents ---
Write-Host "`nInstalling agents..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$ClaudeDir\agents" -Force | Out-Null
Get-ChildItem "$ScriptDir\agents\*.md" | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    Install-PantheonFile $_.FullName "$ClaudeDir\agents\$($_.Name)" $_.Name
}

# --- Install Commands ---
Write-Host "`nInstalling commands..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$ClaudeDir\commands" -Force | Out-Null
Get-ChildItem "$ScriptDir\commands\*.md" | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    Install-PantheonFile $_.FullName "$ClaudeDir\commands\$($_.Name)" $_.Name
}

# --- Install Hooks ---
Write-Host "`nInstalling hooks..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$ClaudeDir\hooks" -Force | Out-Null
Get-ChildItem "$ScriptDir\hooks\*" | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    Install-PantheonFile $_.FullName "$ClaudeDir\hooks\$($_.Name)" $_.Name
}

# --- Install Skills ---
Write-Host "`nInstalling skills..." -ForegroundColor Cyan
$skillDirs = @("dream-consolidation", "autoresearch")
foreach ($skill in $skillDirs) {
    $dest = "$ClaudeDir\skills\$skill"
    if (Test-Path $dest) {
        Write-Host "  [SKIP] $skill (already exists)" -ForegroundColor Yellow
        $skipped++
    } else {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Copy-Item "$ScriptDir\skills\$skill\*" $dest -Recurse
        Write-Host "  [INSTALL] $skill" -ForegroundColor Green
        $installed++
    }
}

# --- Install CARL ---
Write-Host "`nInstalling CARL domains..." -ForegroundColor Cyan
if (Test-Path "$CarlDir\carl.json") {
    Write-Host "  [SKIP] carl.json (already exists)" -ForegroundColor Yellow
    $skipped++
} else {
    New-Item -ItemType Directory -Path $CarlDir -Force | Out-Null
    Copy-Item "$ScriptDir\config\carl-domains.json" "$CarlDir\carl.json"
    Write-Host "  [INSTALL] carl.json (7 domains, 33 rules)" -ForegroundColor Green
    $installed++
}

# --- Config ---
Write-Host "`nInstalling config..." -ForegroundColor Cyan
Install-PantheonFile "$ScriptDir\config\orchestration-engine.md" "$ClaudeDir\ORCHESTRATION-ENGINE.md" "orchestration-engine.md"
Install-PantheonFile "$ScriptDir\config\capability-registry.md" "$ClaudeDir\CAPABILITY-REGISTRY.md" "capability-registry.md"

# --- Summary ---
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Claude Pantheon V$PANTHEON_VERSION installed!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Installed: $installed" -ForegroundColor Green
Write-Host "  Skipped:   $skipped (already existed)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Backup at: $BackupDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Green
Write-Host "  1. Restart Claude Code"
Write-Host "  2. Run /healthcheck to verify"
Write-Host "  3. Try: autopilot: explain this codebase"
Write-Host ""
