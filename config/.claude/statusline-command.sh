#!/usr/bin/env bash

input=$(cat)

# Parse all fields from JSON input
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
thinking=$(echo "$input" | jq -r '.thinking.enabled // empty')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')

# Git branch
branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- Identity (model, effort, thinking, directory, branch) and lines changed ---
LINE1=""
[ -n "$model" ] && LINE1="🤖 $model"
[ -n "$effort" ] && LINE1="${LINE1:+$LINE1 | }🎚️ $(printf '\033[35m%s\033[0m' "$effort")"
[ "$thinking" = "true" ] && LINE1="${LINE1:+$LINE1 | }💭 $(printf '\033[35mthinking\033[0m')"
[ -n "$cwd" ] && LINE1="${LINE1:+$LINE1 | }📁 $(printf '\033[34m%s\033[0m' "${cwd##*/}")"
[ -n "$branch" ] && LINE1="${LINE1:+$LINE1 | }🌿 $(printf '\033[36m%s\033[0m' "$branch")"
if [ -n "$lines_added" ] || [ -n "$lines_removed" ]; then
  LINE1="${LINE1:+$LINE1 | }📝 $(printf '\033[32m+%s\033[0m/\033[31m-%s\033[0m' "${lines_added:-0}" "${lines_removed:-0}")"
fi

echo -e "$LINE1"
