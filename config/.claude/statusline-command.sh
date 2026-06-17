#!/usr/bin/env bash

input=$(cat)

# Parse all fields from JSON input
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
thinking=$(echo "$input" | jq -r '.thinking.enabled // empty')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')
dur_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
api_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // empty')
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // empty')
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
resets_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
resets_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
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

# Milliseconds -> human duration (83000 -> 1m23s, 45000 -> 45s)
human_ms() {
  local total_s=$(( $1 / 1000 ))
  local mins=$(( total_s / 60 ))
  local secs=$(( total_s % 60 ))
  if [ "$mins" -gt 0 ]; then
    echo "${mins}m${secs}s"
  else
    echo "${secs}s"
  fi
}

# Git branch
branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- Line 1: Identity (model, id, effort, thinking, repo, directory, branch) ---
LINE1=""
[ -n "$model" ] && LINE1="🤖 $model"
[ -n "$effort" ] && LINE1="${LINE1:+$LINE1 | }🎚️ $(printf '\033[35m%s\033[0m' "$effort")"
[ "$thinking" = "true" ] && LINE1="${LINE1:+$LINE1 | }💭 $(printf '\033[35mthinking\033[0m')"
[ -n "$cwd" ] && LINE1="${LINE1:+$LINE1 | }📁 $(printf '\033[34m%s\033[0m' "${cwd##*/}")"
[ -n "$branch" ] && LINE1="${LINE1:+$LINE1 | }🌿 $(printf '\033[36m%s\033[0m' "$branch")"

# --- Line 2: Session metrics (cost, lines, durations, context, tokens) ---
LINE2=""
[ -n "$cost" ] && LINE2="💰 $(printf '\033[33m%s\033[0m' "$(printf '$%.2f' "$cost")")"
if [ -n "$lines_added" ] || [ -n "$lines_removed" ]; then
  LINE2="${LINE2:+$LINE2 | }📝 $(printf '\033[32m+%s\033[0m/\033[31m-%s\033[0m' "${lines_added:-0}" "${lines_removed:-0}")"
fi
if [ -n "$dur_ms" ]; then
  if [ -n "$api_ms" ]; then
    LINE2="${LINE2:+$LINE2 | }⏱️ $(printf '\033[37melapsed %s · api wait %s\033[0m' "$(human_ms "$dur_ms")" "$(human_ms "$api_ms")")"
  else
    LINE2="${LINE2:+$LINE2 | }⏱️ $(printf '\033[37melapsed %s\033[0m' "$(human_ms "$dur_ms")")"
  fi
fi
if [ -n "$ctx_pct" ]; then
  pct=$(printf '%.0f' "$ctx_pct")
  colour=$(colour_for_pct "$ctx_pct")
  LINE2="${LINE2:+$LINE2 | }🧠 $(printf '%b' "${colour}Context: ${pct}%\033[0m")"
fi
[ "$exceeds_200k" = "true" ] && LINE2="${LINE2:+$LINE2 | }⚠️ $(printf '\033[31m>200k\033[0m')"

# --- Line 3: Rate limits (Current Session | All models | Sonnet only) ---
LINE3=""

# Current Session — 5-hour
if [ -n "$rate_5h" ]; then
  pct=$(printf '%.0f' "$rate_5h")
  colour=$(colour_for_pct "$rate_5h")
  if [ -n "$resets_5h" ]; then
    remaining=$(countdown "$resets_5h")
    LINE3="✨ Current: $(printf '%b' "${colour}${pct}% resets: ${remaining}\033[0m")"
  else
    LINE3="✨ Current: $(printf '%b' "${colour}${pct}%\033[0m")"
  fi
fi

# All models — 7-day
if [ -n "$rate_7d" ]; then
  pct=$(printf '%.0f' "$rate_7d")
  colour=$(colour_for_pct "$rate_7d")
  if [ -n "$resets_7d" ]; then
    remaining=$(countdown "$resets_7d")
    LINE3="${LINE3:+$LINE3 | }✨ All: $(printf '%b' "${colour}${pct}% resets: ${remaining}\033[0m")"
  else
    LINE3="${LINE3:+$LINE3 | }✨ All: $(printf '%b' "${colour}${pct}%\033[0m")"
  fi
fi

echo -e "$LINE1"
[ -n "$LINE2" ] && echo -e "$LINE2"
[ -n "$LINE3" ] && echo -e "$LINE3"
