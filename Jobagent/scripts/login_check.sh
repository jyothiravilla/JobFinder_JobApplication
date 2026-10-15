#!/bin/bash
# Prints OK if Claude is logged in under cron's bare environment
env -i HOME="$HOME" /bin/bash -c 'export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.npm-global/bin"; [ -f "$HOME/.claude_token.env" ] && { set -a; . "$HOME/.claude_token.env"; set +a; }; claude -p "Reply with the single word OK" --permission-mode auto'
