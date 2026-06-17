#!/usr/bin/env bash

input=$(cat)

# Parse all fields from JSON input
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
thinking=$(echo "$input" | jq -r '.thinking.enabled // empty')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
resets_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
resets_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
rate_opus=$(echo "$input" | jq -r '.rate_limits.seven_day_opus.used_percentage // empty')
resets_opus=$(echo "$input" | jq -r '.rate_limits.seven_day_opus.resets_at // empty')
rate_sonnet=$(echo "$input" | jq -r '.rate_limits.seven_day_sonnet.used_percentage // empty')
resets_sonnet=$(echo "$input" | jq -r '.rate_limits.seven_day_sonnet.resets_at // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Colour thresholds
colour_for_pct() {
  local pct=$1
  if (( $(echo "$pct >= 80" | bc -l) )); then
    printf '\033[31m'  # red
  elif (( $(echo "$pct >= 60" | bc -l) )); then
    printf '\033[33m'  # yellow
  else
    printf '\033[32m'  # green
  fi
}

# Countdown from Unix epoch seconds
countdown() {
  local resets_at=$1
  local now_epoch diff days hours mins
  now_epoch=$(date '+%s')
  diff=$((resets_at - now_epoch))
  if [ "$diff" -le 0 ]; then
    echo "0m"
    return
  fi
  days=$((diff / 86400))
  hours=$(( (diff % 86400) / 3600 ))
  mins=$(( (diff % 3600) / 60 ))
  if [ "$days" -gt 0 ]; then
    echo "${days}d${hours}h"
  elif [ "$hours" -gt 0 ]; then
    echo "${hours}h${mins}m"
  else
    echo "${mins}m"
  fi
}

# Git branch
branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- Line 1: Model, directory, git branch ---
LINE1=""
[ -n "$model" ] && LINE1="🤖 $model"
[ -n "$effort" ] && LINE1="${LINE1:+$LINE1 | }🎚️ $(printf '\033[35m%s\033[0m' "$effort")"
[ "$thinking" = "true" ] && LINE1="${LINE1:+$LINE1 | }💭 $(printf '\033[35mthinking\033[0m')"
[ -n "$cwd" ] && LINE1="${LINE1:+$LINE1 | }📁 $(printf '\033[34m%s\033[0m' "${cwd##*/}")"
[ -n "$branch" ] && LINE1="${LINE1:+$LINE1 | }🌿 $(printf '\033[36m%s\033[0m' "$branch")"

# --- Append cost and context to line 1 ---
[ -n "$cost" ] && LINE1="${LINE1:+$LINE1 | }💰 $(printf '\033[33m%s\033[0m' "$(printf '$%.2f' "$cost")")"
if [ -n "$ctx_pct" ]; then
  pct=$(printf '%.0f' "$ctx_pct")
  colour=$(colour_for_pct "$ctx_pct")
  LINE1="${LINE1:+$LINE1 | }🧠 $(printf '%b' "${colour}Context: ${pct}%\033[0m")"
fi

# --- Line 2: Rate limits (Current Session | All models | Sonnet only) ---
LINE2=""

# Current Session — 5-hour
if [ -n "$rate_5h" ]; then
  pct=$(printf '%.0f' "$rate_5h")
  colour=$(colour_for_pct "$rate_5h")
  if [ -n "$resets_5h" ]; then
    remaining=$(countdown "$resets_5h")
    LINE2="✨ Current: $(printf '%b' "${colour}${pct}% resets: ${remaining}\033[0m")"
  else
    LINE2="✨ Current: $(printf '%b' "${colour}${pct}%\033[0m")"
  fi
fi

# All models — 7-day
if [ -n "$rate_7d" ]; then
  pct=$(printf '%.0f' "$rate_7d")
  colour=$(colour_for_pct "$rate_7d")
  if [ -n "$resets_7d" ]; then
    remaining=$(countdown "$resets_7d")
    LINE2="${LINE2:+$LINE2 | }✨ All: $(printf '%b' "${colour}${pct}% resets: ${remaining}\033[0m")"
  else
    LINE2="${LINE2:+$LINE2 | }✨ All: $(printf '%b' "${colour}${pct}%\033[0m")"
  fi
fi

# Opus only — 7-day
if [ -n "$rate_opus" ]; then
  pct=$(printf '%.0f' "$rate_opus")
  colour=$(colour_for_pct "$rate_opus")
  if [ "$pct" -ge 100 ] && [ -n "$resets_opus" ]; then
    remaining=$(countdown "$resets_opus")
    LINE2="${LINE2:+$LINE2 | }✨ Opus: $(printf '%b' "${colour}${pct}% resets: ${remaining}\033[0m")"
  else
    LINE2="${LINE2:+$LINE2 | }✨ Opus: $(printf '%b' "${colour}${pct}%\033[0m")"
  fi
fi

# Sonnet only — 7-day
if [ -n "$rate_sonnet" ]; then
  pct=$(printf '%.0f' "$rate_sonnet")
  colour=$(colour_for_pct "$rate_sonnet")
  if [ "$pct" -ge 100 ] && [ -n "$resets_sonnet" ]; then
    remaining=$(countdown "$resets_sonnet")
    LINE2="${LINE2:+$LINE2 | }✨ Sonnet: $(printf '%b' "${colour}${pct}% resets: ${remaining}\033[0m")"
  else
    LINE2="${LINE2:+$LINE2 | }✨ Sonnet: $(printf '%b' "${colour}${pct}%\033[0m")"
  fi
fi

echo -e "$LINE1"
[ -n "$LINE2" ] && echo -e "$LINE2"
