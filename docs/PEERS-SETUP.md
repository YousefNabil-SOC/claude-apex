# Claude Peers: Multi-Terminal Communication

## Overview

Claude Peers allows multiple Claude Code instances (in different terminal windows/tabs) to communicate and coordinate work:

```
Terminal 1          Terminal 2          Terminal 3
(Planner)          (Executor 1)        (Executor 2)
  ↓                  ↓                   ↓
┌─────────────────────────────────────────────┐
│ Peers Broker (localhost:7899)                │
│ - Peer discovery                            │
│ - Message routing                           │
│ - Shared memory                             │
└─────────────────────────────────────────────┘
```

**Use case**: Planner drafts a plan in Terminal 1, Executors in Terminals 2-3 receive it and work in parallel.

## Quick Setup

### Step 1: Start Broker (Once per machine)

```bash
cd ~/.claude
bash hooks/peers-auto-register.sh
```

Output:
```
✓ Peers broker started on localhost:7899
✓ Auto-registration enabled
✓ Your instance: peer-terminal-1
```

### Step 2: Verify Connection

In any terminal:
```bash
# List all connected peers
list_peers

# Output:
Peer 1: peer-terminal-1 (status: planning)
Peer 2: peer-terminal-2 (status: executor)
Peer 3: peer-terminal-3 (status: idle)
```

### Step 3: Announce What You're Doing

```bash
set_summary "Planner: Creating sprint plan"

# Or in Executor terminal:
set_summary "Executor: Implementing Story 1"
```

## Peer Commands

### list_peers
**Lists all connected instances**

```bash
list_peers

# Output:
Connected Peers (localhost:7899):
1. peer-terminal-1 (Summary: Planner for [YOUR_PROJECT])
2. peer-terminal-2 (Summary: Executor - Story 1)
3. peer-terminal-3 (Summary: Executor - Story 2)
4. peer-terminal-4 (Summary: Idle)
```

### set_summary
**Announce what you're working on**

```bash
set_summary "Working on: Authentication refactor"

# Visible to all peers via list_peers
```

### send_message
**Send message to another peer**

```bash
send_message peer-terminal-2 "Story 1 plan ready, see shared memory key: sprint/story1"

# Or send to all
send_message all "Committing sprint plan to docs/SPRINT-PLAN.md"
```

### receive_message
**Check messages for you**

```bash
receive_message
# Shows all pending messages
```

## Broker Architecture

### Broker Location
```bash
localhost:7899
```

Auto-started by: `~/.claude/hooks/peers-auto-register.sh`

### Peer Discovery
```
New terminal opened
  ↓
Claude Code detects broker on 7899
  ↓
Self-registers: peer-terminal-N
  ↓
Visible to all other peers
```

### Shared Memory
```bash
# All peers write to same shared location
~/.claude/memory/peers/shared/

# Example:
~/.claude/memory/peers/shared/sprint/story1.md
~/.claude/memory/peers/shared/blockers.md
~/.claude/memory/peers/shared/decisions.log
```

## Common Workflows

### Workflow 1: Planner + 2 Executors

**Terminal 1 (Planner)**:
```bash
set_summary "Planner: Creating sprint structure"

/deep-interview "Our sprint goals"
/paul:plan "Sprint implementation"

# Save plan to shared location
cp ~/SPRINT-PLAN.md ~/.claude/memory/peers/shared/

send_message all "Sprint plan ready! See shared/SPRINT-PLAN.md"
```

**Terminal 2 (Executor 1)**:
```bash
set_summary "Executor 1: Story 1 - Backend"

# Wait for message
receive_message
# Output: "Sprint plan ready! See shared/SPRINT-PLAN.md"

# Read shared plan
cat ~/.claude/memory/peers/shared/SPRINT-PLAN.md

# Work on assigned story
autopilot: "Implement backend for Story 1"

# Notify planner
send_message peer-terminal-1 "Story 1 complete, PR #234"
```

**Terminal 3 (Executor 2)**:
```bash
set_summary "Executor 2: Story 2 - Frontend"

receive_message
cat ~/.claude/memory/peers/shared/SPRINT-PLAN.md

autopilot: "Implement frontend for Story 2"

send_message peer-terminal-1 "Story 2 complete, PR #235"
```

### Workflow 2: Shared Blockers Board

**Any terminal**:
```bash
# Executor 1 is blocked
echo "Story 1: Waiting for API design" >> ~/.claude/memory/peers/shared/blockers.md

send_message all "Blocker added - Story 1 needs API design"

# In Planner terminal
cat ~/.claude/memory/peers/shared/blockers.md
# Sees all blockers across team

# Resolve blocker
echo "" >> ~/.claude/memory/peers/shared/blockers.md  # clear it

send_message all "API design ready! Story 1 unblocked"
```

## Windows Setup

### Prerequisites

```bash
# Git Bash (comes with Git for Windows)
# OR
# Windows Subsystem for Linux (WSL)
```

### Step 1: Start Broker on Windows

```bash
# In any Git Bash/WSL terminal
cd ~/.claude
bash hooks/peers-auto-register.sh
```

### Step 2: Verify Broker Running

```bash
# Check if 7899 is listening
netstat -an | grep 7899
# OR
lsof -i :7899
```

### Step 3: Multi-Terminal on Windows

**Option A: Multiple Git Bash windows**
```bash
# Terminal 1: Start broker
bash hooks/peers-auto-register.sh

# Terminal 2, 3, etc: Auto-connect
list_peers
# Should show all terminals
```

**Option B: Windows Terminal**
```bash
# Window 1 tab: Broker
bash ~/.claude/hooks/peers-auto-register.sh

# Window 1 tab 2: Planner
cd /path/to/project
claude

# Window 1 tab 3: Executor 1
cd /path/to/project
claude

# etc.
```

### Troubleshooting Windows

**Problem**: "localhost:7899 refused connection"

```bash
# Check if broker is running
tasklist | grep node
# Should show node.exe or similar

# Or restart broker
bash ~/.claude/hooks/peers-auto-register.sh
```

**Problem**: "Port 7899 already in use"

```bash
# Find what's using port 7899
netstat -ano | grep 7899
# Kill the process
taskkill /PID <PID> /F
```

**Problem**: Path issues in messages

```bash
# Use Unix-style paths in messages/shared files
❌ C:\Users\YOU\Claude code\project
✅ /c/Users/YOU/Claude code/project
✅ ~/claude-pantheon
```

## Shared Memory Best Practices

### 1. Use clear key names
```bash
~/.claude/memory/peers/shared/sprint/story1/blockers.md
~/.claude/memory/peers/shared/sprint/story1/progress.md
~/.claude/memory/peers/shared/decisions/auth.md
```

### 2. Announce before overwriting
```bash
# Before writing to shared file:
send_message all "Updating shared/story1/progress.md"

# Write
cat > ~/.claude/memory/peers/shared/story1/progress.md

# Announce completion
send_message all "Story 1 progress updated"
```

### 3. Use append for logs
```bash
# Add to decision log (don't overwrite)
echo "2026-04-04 09:15 - Chose JWT over sessions" \
  >> ~/.claude/memory/peers/shared/decisions.log

send_message all "Decision logged"
```

## Peer Patterns

### Pattern 1: Handoff
```bash
# Planner sets up work
set_summary "Setting up Story 1"
# ... create plan ...
send_message peer-terminal-2 "Story 1 ready for execution"

# Executor takes it
set_summary "Executing Story 1"
autopilot: "Implement Story 1"
send_message peer-terminal-1 "Story 1 complete"
```

### Pattern 2: Parallel Review
```bash
# Terminal 1: Author writes code
# Terminal 2: Reviewer checks in parallel
set_summary "Code review - monitoring for changes"

# Whenever author commits:
agent:code-reviewer "Review PR #123"
send_message peer-terminal-1 "Review: 2 issues found"
```

### Pattern 3: Shared Decision Making
```bash
# Planner proposes decision
send_message all "Proposal: Use PostgreSQL for [YOUR_PROJECT]. 
                   See docs/TECHNICAL-DECISION.md. 
                   React with Y/N by 10:00 AM"

# Executors reply
send_message peer-terminal-1 "Executor 1: +1, PostgreSQL chosen"
send_message peer-terminal-1 "Executor 2: +1, agreed"

# Planner confirms
send_message all "Decision FINAL: PostgreSQL. 
                   See shared/decisions/database.md"
```

## Security Notes

### What Peers Can Do
- Send/receive messages (no encryption on localhost)
- Read shared files in `~/.claude/memory/peers/shared/`
- See all peers' summaries

### What Peers Cannot Do
- Access each other's project files
- Execute code in other terminals
- Modify each other's session memory
- Access credentials/secrets (not shared)

### Best Practices
```bash
❌ Don't share API keys in messages
✅ Share decisions, blockers, summaries only

❌ Don't write sensitive data to shared/
✅ Keep sensitive data in ~/.claude/memory/private/

❌ Don't assume all peers are trusted
✅ Verify peer identity before important handoffs
```

## Monitoring Peer Health

```bash
# Check all peers still connected
list_peers | grep "Connected"

# If a peer died:
# 1. It disappears from list_peers within 30 seconds
# 2. You'll get "Peer disconnected" message
# 3. Other peers continue working

# Restart a dead peer:
# Open new terminal, auto-registers as new peer
```

## Troubleshooting

### "Broker not found"
```bash
# Manually start broker
cd ~/.claude
bash hooks/peers-auto-register.sh

# If still fails:
# 1. Check port 7899 is free: netstat -an | grep 7899
# 2. Check firewall allows 127.0.0.1:7899
# 3. Restart broker: pkill -f peers-broker && bash hooks/peers-auto-register.sh
```

### "Message not delivered"
```bash
# Check target peer is still connected
list_peers

# If target not listed, it disconnected
# Resend when it comes back, or message all peers
send_message all "Update for whoever is listening..."
```

### "Shared memory file corruption"
```bash
# Shared files are plain text, check for conflicts
cat ~/.claude/memory/peers/shared/problematic-file.md

# Rewrite cleanly
echo "Fresh content" > ~/.claude/memory/peers/shared/problematic-file.md

# Announce fix
send_message all "Shared memory refreshed"
```

## Integration with Other Features

### Peers + PAUL
```bash
# Terminal 1: Planner creates PAUL plan
/paul:plan "Sprint work"

# Terminal 2-3: Executors read plan
cat ~/.claude/memory/peers/shared/SPRINT-PAUL-PLAN.md

# All: Share progress
send_message all "Phase 1 complete"
```

### Peers + OMC team
```bash
# Terminal 1: Start team execution
team 3:executor "Story 1" "Story 2" "Story 3"

# Terminals 2-4: Auto-created for each task
# They auto-register as peers
list_peers
# Shows 4 peers (planner + 3 executors)
```

---

**Next**: [MEMORY-SYSTEM.md](./MEMORY-SYSTEM.md) → Understand session persistence and auto-save
