#!/bin/bash
# Installs the agent files into ~/job-agent. Existing files are never overwritten.
set -e
SRC="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${JOB_AGENT_HOME:-$HOME/job-agent}"
echo "Installing into $DEST (existing files are kept)"
mkdir -p "$DEST/scripts" "$DEST/resumes/tailored" "$DEST/review" "$DEST/outbox" "$DEST/logs"
for f in "$SRC"/scripts/*; do b=$(basename "$f"); [ -e "$DEST/scripts/$b" ] || cp "$f" "$DEST/scripts/$b"; done
chmod 700 "$DEST"/scripts/*.sh "$DEST"/scripts/*.py 2>/dev/null || true
copy_if_missing() { if [ -e "$2" ]; then echo "kept existing $2"; else cp "$1" "$2"; echo "created $2"; fi; }
copy_if_missing "$SRC/templates/profile.example.md" "$DEST/profile.md"
copy_if_missing "$SRC/templates/sources.example.md" "$DEST/sources.md"
copy_if_missing "$SRC/templates/CLAUDE.md.template" "$DEST/CLAUDE.md"
copy_if_missing "$SRC/templates/secrets.env.example" "$DEST/secrets.env"
chmod 600 "$DEST/secrets.env"
for n in companies jobs tracker accounts; do copy_if_missing "$SRC/templates/data/$n.csv.example" "$DEST/$n.csv"; done
chmod 600 "$DEST/accounts.csv"
copy_if_missing "$SRC/scripts/banned_terms.example.txt" "$DEST/scripts/banned_terms.txt"
if ! grep -q "job-agent aliases" "$HOME/.bashrc" 2>/dev/null; then
  printf '\n# job-agent aliases\nsource "%s/scripts/aliases.sh"\n' "$DEST" >> "$HOME/.bashrc"
  echo "added aliases to ~/.bashrc"
fi
echo
echo "Next: edit profile.md, sources.md, CLAUDE.md (replace every <PLACEHOLDER>) and secrets.env in $DEST,"
echo "then follow docs/setup-guide.md. Run: source ~/.bashrc"
