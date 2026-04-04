#!/usr/bin/env python3
"""
CARL JIT Rule Injection Hook
Fires on UserPromptSubmit to load relevant domain rules.

Reads the user's prompt from stdin, checks against CARL domain
recall keywords, and outputs matching rules as additional context.
"""

import json
import os
import sys

def main():
    carl_path = os.path.join(os.path.expanduser("~"), ".carl", "carl.json")

    if not os.path.exists(carl_path):
        return

    try:
        with open(carl_path, "r", encoding="utf-8") as f:
            carl = json.load(f)
    except (json.JSONDecodeError, IOError):
        return

    # Read prompt from environment or stdin
    prompt = os.environ.get("PROMPT", "").lower()
    if not prompt:
        try:
            prompt = sys.stdin.read().lower()
        except Exception:
            return

    if not prompt:
        return

    domains = carl.get("domains", {})
    active_rules = []

    for domain_name, domain in domains.items():
        if domain.get("state") != "active":
            continue

        # Always-on domains
        if domain.get("always_on"):
            for rule in domain.get("rules", []):
                active_rules.append(f"[{domain_name}] {rule.get('text', '')}")
            continue

        # Check recall keywords
        recall = domain.get("recall", [])
        for keyword in recall:
            if keyword.lower() in prompt:
                for rule in domain.get("rules", []):
                    active_rules.append(f"[{domain_name}] {rule.get('text', '')}")
                break

    if active_rules:
        print("<carl-rules>")
        for rule in active_rules:
            print(f"- {rule}")
        print("</carl-rules>")

if __name__ == "__main__":
    main()
