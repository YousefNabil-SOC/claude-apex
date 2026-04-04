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

# --- Configure MCP Servers ---
Write-Host "`nConfiguring MCP servers..." -ForegroundColor Cyan
$settingsPath = "$ClaudeDir\settings.json"
if (Test-Path $settingsPath) {
    $pyScript = @'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)

if "mcpServers" not in settings:
    settings["mcpServers"] = {}

servers_to_add = {
    "context7": {"command": "npx", "args": ["-y", "@context7/mcp-server"]},
    "playwright": {"command": "npx", "args": ["-y", "@playwright/mcp"]},
    "memory": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-memory"]},
    "sequential-thinking": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]}
}

added = 0
for name, config in servers_to_add.items():
    if name not in settings["mcpServers"]:
        settings["mcpServers"][name] = config
        print(f"  [INSTALL] MCP server: {name}")
        added += 1
    else:
        print(f"  [SKIP] MCP server: {name} (already exists)")

if added > 0:
    with open(settings_path, 'w') as f:
        json.dump(settings, f, indent=2)
    print(f"  {added} MCP servers added to settings.json")
else:
    print("  All MCP servers already configured")
'@
    $pyScript | python3 -
} else {
    Write-Host "  [SKIP] No settings.json found" -ForegroundColor Yellow
}

# --- Configure Hooks in settings.json ---
Write-Host "`nConfiguring hooks in settings.json..." -ForegroundColor Cyan
if (Test-Path $settingsPath) {
    $pyHooks = @'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)

if "hooks" not in settings:
    settings["hooks"] = {}

changed = False

if "PostCompact" not in settings["hooks"]:
    settings["hooks"]["PostCompact"] = [
        {"type": "command", "command": "bash $HOME/.claude/hooks/post-compact-recovery.sh"}
    ]
    print("  [INSTALL] PostCompact hook")
    changed = True
else:
    print("  [SKIP] PostCompact hook (already exists)")

if "Stop" not in settings["hooks"]:
    settings["hooks"]["Stop"] = []

stop_hooks = settings["hooks"]["Stop"]
existing_commands = [h.get("command", "") for h in stop_hooks if isinstance(h, dict)]

if not any("session-end-save" in c for c in existing_commands):
    stop_hooks.append({"type": "command", "command": "bash $HOME/.claude/hooks/session-end-save.sh"})
    print("  [INSTALL] session-end-save Stop hook")
    changed = True

if not any("task-complete-sound" in c for c in existing_commands):
    stop_hooks.append({"type": "command", "command": "bash $HOME/.claude/hooks/task-complete-sound.sh"})
    print("  [INSTALL] task-complete-sound Stop hook")
    changed = True

if changed:
    with open(settings_path, 'w') as f:
        json.dump(settings, f, indent=2)
    print("  Hooks configured in settings.json")
else:
    print("  All hooks already configured")
'@
    $pyHooks | python3 -
} else {
    Write-Host "  [SKIP] No settings.json found" -ForegroundColor Yellow
}

# --- Plugin Installation Instructions ---
Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "  IMPORTANT: Complete these steps in Claude Code" -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Open Claude Code and run these commands to install"
Write-Host "  the plugins that bring 1,000+ skills and 19 agents:"
Write-Host ""
Write-Host "  1. Install everything-claude-code (1,000+ skills):"
Write-Host "     /plugin marketplace add https://github.com/anthropic-community/everything-claude-code"
Write-Host "     /plugin install everything-claude-code"
Write-Host ""
Write-Host "  2. Install oh-my-claudecode (19 agents, autopilot):"
Write-Host "     /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode"
Write-Host "     /plugin install oh-my-claudecode"
Write-Host ""
Write-Host "  3. Run OMC setup:"
Write-Host "     /oh-my-claudecode:omc-setup"
Write-Host ""
Write-Host "  4. Verify everything:"
Write-Host "     /healthcheck"
Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan

# --- Post-Install Verification ---
Write-Host ""
Write-Host "[PANTHEON] Running post-install verification..."
$verifyScript = Join-Path $ScriptDir "verify.sh"
if (Test-Path $verifyScript) {
    & bash $verifyScript
}

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
