# Claude Apex V7 Installer (Windows PowerShell)
# Non-destructive: backs up everything before changes
# Author: Engineer Yousef Nabil -- https://github.com/YousefNabil-SOC/claude-apex

$ErrorActionPreference = "Stop"
$APEX_VERSION = "7.0.0"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$CarlDir = Join-Path $env:USERPROFILE ".carl"
$BackupDir = Join-Path $ClaudeDir "backups\pre-apex-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

$installed = 0
$skipped = 0

function Write-Banner {
    Write-Host ""
    Write-Host "=============================================="
    Write-Host "  Claude Apex V$APEX_VERSION - Installation"
    Write-Host "  by Engineer Yousef Nabil"
    Write-Host "  github.com/YousefNabil-SOC/claude-apex"
    Write-Host "=============================================="
    Write-Host ""
    Write-Host "  1,276+ skills. 108 agents. 182 commands." -ForegroundColor Cyan
    Write-Host "  Three-layer auto-routing. One unified brain." -ForegroundColor Cyan
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

function Install-ApexFile {
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

function Install-ApexDir {
    param($Source, $Dest, $Label)
    if (Test-Path $Dest) {
        Write-Host "  [SKIP] $Label (already exists)" -ForegroundColor Yellow
        $script:skipped++
    } else {
        New-Item -ItemType Directory -Path $Dest -Force | Out-Null
        Copy-Item "$Source\*" $Dest -Recurse -Force
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
Write-Host "This will install Claude Apex V$APEX_VERSION to ~/.claude/." -ForegroundColor Yellow
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
if (Test-Path "$ClaudeDir\PRIMER.md") { Copy-Item "$ClaudeDir\PRIMER.md" $BackupDir }
if (Test-Path "$ClaudeDir\agents") { Copy-Item "$ClaudeDir\agents" "$BackupDir\agents" -Recurse }
if (Test-Path "$ClaudeDir\commands") { Copy-Item "$ClaudeDir\commands" "$BackupDir\commands" -Recurse }
if (Test-Path "$ClaudeDir\hooks") { Copy-Item "$ClaudeDir\hooks" "$BackupDir\hooks" -Recurse }
if (Test-Path $CarlDir) { Copy-Item $CarlDir "$BackupDir\carl-backup" -Recurse }
Write-Host "  [OK] Backup saved to $BackupDir" -ForegroundColor Green

# --- Install Agents (25 specialists) ---
Write-Host "`nInstalling agents (25 specialists)..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$ClaudeDir\agents" -Force | Out-Null
Get-ChildItem "$ScriptDir\agents\*.md" | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    Install-ApexFile $_.FullName "$ClaudeDir\agents\$($_.Name)" $_.Name
}

# --- Install Commands (~45 top-level + 3 subdirs) ---
Write-Host "`nInstalling commands..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$ClaudeDir\commands" -Force | Out-Null
Get-ChildItem "$ScriptDir\commands\*.md" | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    Install-ApexFile $_.FullName "$ClaudeDir\commands\$($_.Name)" $_.Name
}
# Subdirs (paul, seed, autoresearch)
foreach ($subdir in @("paul", "seed", "autoresearch")) {
    if (Test-Path "$ScriptDir\commands\$subdir") {
        Install-ApexDir "$ScriptDir\commands\$subdir" "$ClaudeDir\commands\$subdir" "commands/$subdir"
    }
}

# --- Install Hooks (V7 -- 7 hooks) ---
Write-Host "`nInstalling hooks (V7 fixed versions)..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$ClaudeDir\hooks" -Force | Out-Null
Get-ChildItem "$ScriptDir\hooks\*" | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    Install-ApexFile $_.FullName "$ClaudeDir\hooks\$($_.Name)" $_.Name
}

# --- Install Skills (V7 -- 9 custom Apex skills) ---
Write-Host "`nInstalling Apex skills (9 custom)..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$ClaudeDir\skills" -Force | Out-Null
$skillDirs = @(
    "dream-consolidation",
    "autoresearch",
    "premium-web-design",
    "21st-dev-magic",
    "instagram-access",
    "graphify",
    "graphic-design-studio",
    "impeccable",
    "fireworks-tech-graph"
)
foreach ($skill in $skillDirs) {
    if (Test-Path "$ScriptDir\skills\$skill") {
        Install-ApexDir "$ScriptDir\skills\$skill" "$ClaudeDir\skills\$skill" "skill: $skill"
    }
}

# --- Install CARL (V7 -- 9 domains, 40 rules) ---
Write-Host "`nInstalling CARL domains (9 domains, 40 rules)..." -ForegroundColor Cyan
if (Test-Path "$CarlDir\carl.json") {
    Write-Host "  [SKIP] carl.json (already exists)" -ForegroundColor Yellow
    $skipped++
} else {
    New-Item -ItemType Directory -Path $CarlDir -Force | Out-Null
    Copy-Item "$ScriptDir\config\carl-domains.json" "$CarlDir\carl.json"
    Write-Host "  [INSTALL] carl.json (9 domains, 40 rules)" -ForegroundColor Green
    $installed++
}

# --- Install Config Files (V7 three-layer routing) ---
Write-Host "`nInstalling config files (V7 three-layer routing)..." -ForegroundColor Cyan
Install-ApexFile "$ScriptDir\config\orchestration-engine.md" "$ClaudeDir\ORCHESTRATION-ENGINE.md" "ORCHESTRATION-ENGINE.md"
Install-ApexFile "$ScriptDir\config\capability-registry.md" "$ClaudeDir\CAPABILITY-REGISTRY.md" "CAPABILITY-REGISTRY.md"
Install-ApexFile "$ScriptDir\config\command-registry.md" "$ClaudeDir\COMMAND-REGISTRY.md" "COMMAND-REGISTRY.md"
Install-ApexFile "$ScriptDir\config\agents.md" "$ClaudeDir\AGENTS.md" "AGENTS.md"
Install-ApexFile "$ScriptDir\config\auto-activation-matrix.md" "$ClaudeDir\AUTO-ACTIVATION-MATRIX.md" "AUTO-ACTIVATION-MATRIX.md"

# --- CLAUDE.md / PRIMER.md templates ---
Write-Host "`nChecking CLAUDE.md and PRIMER.md..." -ForegroundColor Cyan
if (-not (Test-Path "$ClaudeDir\CLAUDE.md")) {
    Copy-Item "$ScriptDir\config\claude-md-template.md" "$ClaudeDir\CLAUDE.md"
    Write-Host "  [INSTALL] Created CLAUDE.md from template" -ForegroundColor Green
    $installed++
} else {
    Write-Host "  [SKIP] CLAUDE.md already exists (edit manually if needed)" -ForegroundColor Yellow
}
if (-not (Test-Path "$ClaudeDir\PRIMER.md")) {
    Copy-Item "$ScriptDir\config\primer-template.md" "$ClaudeDir\PRIMER.md"
    Write-Host "  [INSTALL] Created PRIMER.md from template (edit with your profile)" -ForegroundColor Green
    $installed++
} else {
    Write-Host "  [SKIP] PRIMER.md already exists" -ForegroundColor Yellow
}

# --- .env template ---
Write-Host "`nSetting up .env template..." -ForegroundColor Cyan
if (-not (Test-Path "$ClaudeDir\.env")) {
    Copy-Item "$ScriptDir\config\env.template" "$ClaudeDir\.env"
    Write-Host "  [INSTALL] Created ~/.claude/.env from template" -ForegroundColor Green
    Write-Host "  [ACTION] Edit ~/.claude/.env and add your real API keys" -ForegroundColor Yellow
    $installed++
} else {
    Write-Host "  [SKIP] ~/.claude/.env already exists" -ForegroundColor Yellow
}

# --- Third-party dependencies ---
Write-Host "`nChecking third-party dependencies..." -ForegroundColor Cyan
try {
    $bunVer = & bun --version 2>&1
    Write-Host "  [OK] Bun already installed ($bunVer)" -ForegroundColor Green
} catch {
    Write-Host "  [INFO] Installing Bun (optional)..." -ForegroundColor Yellow
    try {
        npm install -g bun 2>&1 | Out-Null
        Write-Host "  [OK] Bun installed" -ForegroundColor Green
    } catch {
        Write-Host "  [SKIP] Bun install failed (optional)" -ForegroundColor Yellow
    }
}

# --- Configure MCP Servers (V7 defaults: playwright, github, exa-web-search, @21st-dev/magic) ---
Write-Host "`nConfiguring MCP servers (4 Apex defaults)..." -ForegroundColor Cyan
$settingsPath = "$ClaudeDir\settings.json"
$pyMCP = @'
import json, os, sys, shutil

settings_path = os.path.expanduser("~/.claude/settings.json")
script_dir = os.environ.get("APEX_SCRIPT_DIR", ".")

if not os.path.exists(settings_path):
    # Seed from V7 template
    template = os.path.join(script_dir, "config", "settings-template.json")
    if os.path.exists(template):
        shutil.copy(template, settings_path)
        print("  [INSTALL] Created settings.json from V7 template")
        sys.exit(0)
    else:
        print("  [SKIP] No settings.json and no template found")
        sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)

if "mcpServers" not in settings:
    settings["mcpServers"] = {}

servers_to_add = {
    "playwright": {
        "command": "npx", "args": ["-y", "@playwright/mcp"],
        "description": "Browser automation, E2E testing, web scraping"
    },
    "github": {
        "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"},
        "description": "GitHub PRs, issues, repos"
    },
    "exa-web-search": {
        "command": "npx", "args": ["-y", "exa-mcp-server"],
        "env": {"EXA_API_KEY": "${EXA_API_KEY}"},
        "description": "Deep web research"
    },
    "@21st-dev/magic": {
        "command": "npx", "args": ["-y", "@21st-dev/magic@latest"],
        "env": {"API_KEY": "${TWENTY_FIRST_DEV_API_KEY}"},
        "description": "Premium React component generation"
    }
}

added = 0
for name, config in servers_to_add.items():
    if name not in settings["mcpServers"]:
        settings["mcpServers"][name] = config
        print(f"  [INSTALL] MCP: {name}")
        added += 1
    else:
        print(f"  [SKIP] MCP: {name} (already exists)")

# V7 env block
settings.setdefault("env", {})
for k, v in {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "FAL_KEY": "${FAL_KEY}",
    "ENABLE_PROMPT_CACHING_1H": "1"
}.items():
    if k not in settings["env"]:
        settings["env"][k] = v
        added += 1

# Enforce effort=high
if settings.get("effortLevel") in (None, "xhigh", "max"):
    settings["effortLevel"] = "high"
    print("  [FIX] effortLevel set to 'high' (self-healing enforced)")
    added += 1

if added > 0:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
    print(f"  {added} settings updates applied")
else:
    print("  All MCP servers + env already configured")

print("")
print("  NOTE: Add your API keys to ~/.claude/.env:")
print("    FAL_KEY, GITHUB_PERSONAL_ACCESS_TOKEN, EXA_API_KEY, TWENTY_FIRST_DEV_API_KEY")
'@

$env:APEX_SCRIPT_DIR = $ScriptDir
$pyMCP | python3 -

# --- Configure Hooks (V7 five-event chain) ---
Write-Host "`nConfiguring hooks in settings.json (5 events)..." -ForegroundColor Cyan
$pyHooks = @'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    print("  [SKIP] No settings.json")
    sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)
settings.setdefault("hooks", {})
changed = False
HOOK_HOME = "$HOME/.claude/hooks"

def has_cmd(event_list, substr):
    for group in event_list:
        for h in group.get("hooks", []):
            if substr in h.get("command", ""):
                return True
    return False

# PostCompact
settings["hooks"].setdefault("PostCompact", [])
if not has_cmd(settings["hooks"]["PostCompact"], "post-compact-recovery"):
    settings["hooks"]["PostCompact"].append({
        "matcher": "",
        "hooks": [{"type": "command", "command": f"bash {HOOK_HOME}/post-compact-recovery.sh"}]
    })
    print("  [INSTALL] PostCompact hook"); changed = True

# Stop (session-end-save + task-complete-sound)
settings["hooks"].setdefault("Stop", [])
if not has_cmd(settings["hooks"]["Stop"], "session-end-save"):
    settings["hooks"]["Stop"].append({
        "matcher": "",
        "hooks": [
            {"type": "command", "command": f"bash {HOOK_HOME}/session-end-save.sh"},
            {"type": "command", "command": f"bash {HOOK_HOME}/task-complete-sound.sh"}
        ]
    })
    print("  [INSTALL] Stop hooks (session-end-save + task-complete-sound)"); changed = True

# UserPromptSubmit -- CARL
settings["hooks"].setdefault("UserPromptSubmit", [])
if not has_cmd(settings["hooks"]["UserPromptSubmit"], "carl-hook"):
    settings["hooks"]["UserPromptSubmit"].append({
        "hooks": [{"type": "command", "command": f"python3 {HOOK_HOME}/carl-hook.py"}]
    })
    print("  [INSTALL] UserPromptSubmit hook (CARL)"); changed = True

# SessionStart -- chain
settings["hooks"].setdefault("SessionStart", [])
if not has_cmd(settings["hooks"]["SessionStart"], "session-start-check"):
    settings["hooks"]["SessionStart"].append({
        "matcher": "",
        "hooks": [
            {"type": "command", "command": f"bash {HOOK_HOME}/session-start-check.sh"},
            {"type": "command", "command": f"bash {HOOK_HOME}/project-auto-graph.sh"}
        ]
    })
    print("  [INSTALL] SessionStart hook chain"); changed = True

if changed:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
    print("  Hooks saved")
else:
    print("  All hooks already configured")
'@

$pyHooks | python3 -

# --- Plugin Installation Instructions ---
Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "  IMPORTANT: Complete these steps in Claude Code" -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Open Claude Code and run these to unlock 1,000+ skills and 19 OMC agents:"
Write-Host ""
Write-Host "  1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code"
Write-Host "  2. /plugin install everything-claude-code"
Write-Host ""
Write-Host "  3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode"
Write-Host "  4. /plugin install oh-my-claudecode"
Write-Host "  5. /oh-my-claudecode:omc-setup"
Write-Host ""
Write-Host "  6. /healthcheck"
Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan

# --- Post-Install Verification ---
Write-Host ""
Write-Host "[APEX] Running post-install verification..."
$verifyScript = Join-Path $ScriptDir "verify.sh"
if (Test-Path $verifyScript) {
    & bash $verifyScript
}

# --- Summary ---
Write-Host ""
Write-Host "=============================================="
Write-Host "  Claude Apex V$APEX_VERSION installed successfully!"
Write-Host "  Prepared by Engineer Yousef Nabil"
Write-Host "  Star the repo: github.com/YousefNabil-SOC/claude-apex"
Write-Host "=============================================="
Write-Host ""
Write-Host "  Installed: $installed" -ForegroundColor Green
Write-Host "  Skipped:   $skipped (already existed)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Backup at: $BackupDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Green
Write-Host "  1. Edit ~/.claude/.env with your API keys"
Write-Host "  2. Edit ~/.claude/PRIMER.md with your profile"
Write-Host "  3. Restart Claude Code"
Write-Host "  4. Run /healthcheck to verify"
Write-Host "  5. Try: autopilot: explain this codebase"
Write-Host ""
Write-Host "  Never used Claude Code? Start with: docs/00-START-HERE.md"
Write-Host "  To uninstall: bash uninstall.sh"
Write-Host ""
