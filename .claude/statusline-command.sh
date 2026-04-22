#!/usr/bin/env bash
# Claude Code status line: tokens, context used/total, and rate-limit progress bars
# Requires jq (bundled with Claude Code environment)

input=$(cat)

# ── Parse all values via jq ────────────────────────────────────────────────
total_in=$(echo "$input"    | jq -r '.context_window.total_input_tokens  // empty')
total_out=$(echo "$input"   | jq -r '.context_window.total_output_tokens // empty')
ctx_window=$(echo "$input"  | jq -r '.context_window.context_window_size // empty')
remaining=$(echo "$input"   | jq -r '.context_window.remaining_percentage // empty')
used=$(echo "$input"        | jq -r '.context_window.used_percentage      // empty')
cur_in=$(echo "$input"      | jq -r '.context_window.current_usage.input_tokens // empty')
five_pct=$(echo "$input"    | jq -r '.rate_limits.five_hour.used_percentage  // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at        // empty')
seven_pct=$(echo "$input"   | jq -r '.rate_limits.seven_day.used_percentage  // empty')

# ── Progress bar helper (10 chars wide) ────────────────────────────────────
bar() {
  local pct="${1:-0}"
  local filled=$(awk "BEGIN{v=int(($pct/100)*10+0.5); if(v>10)v=10; if(v<0)v=0; print v}")
  local empty=$(( 10 - filled ))
  local out=""
  local i
  for ((i=0; i<filled; i++)); do out="${out}█"; done
  for ((i=0; i<empty; i++)); do out="${out}░"; done
  printf '%s' "$out"
}

# ── Color helpers ──────────────────────────────────────────────────────────
RED='\033[0;31m'
YEL='\033[0;33m'
GRN='\033[0;32m'
CYN='\033[0;36m'
DIM='\033[2m'
RST='\033[0m'

context_color() {
  local pct="${1:-100}"
  local result=$(awk "BEGIN{if($pct<20)print \"red\"; else if($pct<50)print \"yel\"; else print \"grn\"}")
  case "$result" in
    red) printf '%s' "$RED";;
    yel) printf '%s' "$YEL";;
    *)   printf '%s' "$GRN";;
  esac
}

limit_color() {
  local pct="${1:-0}"
  local result=$(awk "BEGIN{if($pct>80)print \"red\"; else if($pct>50)print \"yel\"; else print \"grn\"}")
  case "$result" in
    red) printf '%s' "$RED";;
    yel) printf '%s' "$YEL";;
    *)   printf '%s' "$GRN";;
  esac
}

# ── Token segment ─────────────────────────────────────────────────────────
token_seg=""
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  in_k=$(awk "BEGIN{printf \"%.1fk\", $total_in/1000}")
  out_k=$(awk "BEGIN{printf \"%.1fk\", $total_out/1000}")
  token_seg=$(printf "${DIM}in:${RST}${CYN}%s${RST} ${DIM}out:${RST}${CYN}%s${RST}" "$in_k" "$out_k")
fi

# ── Context segment ───────────────────────────────────────────────────────
ctx_seg=""
if [ -n "$remaining" ] && [ -n "$ctx_window" ]; then
  col=$(context_color "$remaining")
  # Use current_usage input_tokens if available, otherwise fall back to total_in
  ctx_used="${cur_in:-${total_in:-0}}"
  used_k=$(awk "BEGIN{
    v = $ctx_used / 1000
    if (v >= 10) printf \"%.0fk\", v
    else         printf \"%.1fk\", v
  }")
  total_k=$(awk "BEGIN{
    v = $ctx_window / 1000
    if (v >= 10) printf \"%.0fk\", v
    else         printf \"%.1fk\", v
  }")
  ctx_seg=$(printf "${DIM}ctx:${RST}${col}%s/%s${RST}" "$used_k" "$total_k")
fi

# ── 5-hour rate limit segment ─────────────────────────────────────────────
five_seg=""
if [ -n "$five_pct" ]; then
  pct_int=$(awk "BEGIN{printf \"%.0f\", $five_pct}")
  col=$(limit_color "$five_pct")
  b=$(bar "$five_pct")

  # Compute countdown to reset
  countdown=""
  if [ -n "$five_resets" ]; then
    now=$(date +%s)
    diff=$(( five_resets - now ))
    if [ "$diff" -gt 0 ]; then
      mins=$(( diff / 60 ))
      hrs=$(( mins / 60 ))
      mins=$(( mins % 60 ))
      countdown=$(printf " ${DIM}resets in ${RST}${CYN}%dh%02dm${RST}" "$hrs" "$mins")
    else
      countdown=$(printf " ${GRN}(reset)${RST}")
    fi
  fi

  five_seg=$(printf "${DIM}5h:${RST}${col}[%s]%s%%%s%s" "$b" "$pct_int" "$RST" "$countdown")
fi

# ── 7-day rate limit segment ──────────────────────────────────────────────
seven_seg=""
if [ -n "$seven_pct" ]; then
  pct_int=$(awk "BEGIN{printf \"%.0f\", $seven_pct}")
  col=$(limit_color "$seven_pct")
  b=$(bar "$seven_pct")
  seven_seg=$(printf "${DIM}7d:${RST}${col}[%s]%s%%%s" "$b" "$pct_int" "$RST")
fi

# ── Assemble line ──────────────────────────────────────────────────────────
parts=()
[ -n "$token_seg" ] && parts+=("$token_seg")
[ -n "$ctx_seg"   ] && parts+=("$ctx_seg")
[ -n "$five_seg"  ] && parts+=("$five_seg")
[ -n "$seven_seg" ] && parts+=("$seven_seg")

sep=$(printf "${DIM} | ${RST}")
out=""
for part in "${parts[@]}"; do
  if [ -z "$out" ]; then
    out="$part"
  else
    out="${out}${sep}${part}"
  fi
done

[ -n "$out" ] && printf "%b\n" "$out"
