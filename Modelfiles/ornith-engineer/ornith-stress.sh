#!/usr/bin/env bash
# ornith-stress.sh — push prompt size toward num_ctx to find the real ceiling
MODEL="${1:-ornith-engineer}"

echo "Benchmarking model: $MODEL"
echo "----------------------------------------"
printf "%-14s %10s %10s %14s\n" "TARGET_TOK" "PROMPT_TOK" "GEN_TOK" "GEN_TOK/S"

for target in 2000 6000 10000 14000; do
  filler=$(python3 -c "
import sys
target = $target
line = '// context filler line representing a chunk of source code context '
n = (target * 4) // len(line)
print(line * n)
")
  prompt="${filler}Given the code context above, write a short Go function that validates an email string with a regex."

  result=$(curl -s http://localhost:11434/api/generate -d "{
    \"model\": \"$MODEL\",
    \"prompt\": $(python3 -c "import json,sys; print(json.dumps(sys.argv[1]))" "$prompt"),
    \"stream\": false
  }")

  prompt_tok=$(echo "$result" | jq -r '.prompt_eval_count // 0')
  gen_tok=$(echo "$result" | jq -r '.eval_count // 0')
  eval_dur_ns=$(echo "$result" | jq -r '.eval_duration // 1')

  if [ "$eval_dur_ns" -gt 0 ] 2>/dev/null; then
    tok_per_sec=$(python3 -c "print(round($gen_tok / ($eval_dur_ns / 1e9), 2))")
  else
    tok_per_sec="ERROR"
  fi

  printf "%-14s %10s %10s %14s\n" "$target" "$prompt_tok" "$gen_tok" "$tok_per_sec"

  err=$(echo "$result" | jq -r '.error // empty')
  if [ -n "$err" ]; then
    echo "  ⚠️  ERROR at target=$target: $err"
  fi
done
