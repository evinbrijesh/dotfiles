#!/usr/bin/env bash
# ornith-bench.sh — quick tokens/sec benchmark across prompt sizes
MODEL="${1:-ornith-engineer}"

declare -A PROMPTS=(
  ["short"]="Write a Go function that checks if a number is prime."
  ["medium"]="Write a Go HTTP server with three endpoints: GET /health, POST /users to create a user, and GET /users/:id to fetch one. Use net/http and no external dependencies."
  ["long_context"]="$(python3 -c "print('// context filler line ' * 800)")Given the code above as context, write a Go function that parses a CSV file and returns a slice of structs."
)

echo "Benchmarking model: $MODEL"
echo "----------------------------------------"
printf "%-14s %10s %10s %14s\n" "PROMPT" "PROMPT_TOK" "GEN_TOK" "GEN_TOK/S"

for label in short medium long_context; do
  prompt="${PROMPTS[$label]}"
  result=$(curl -s http://localhost:11434/api/generate -d "{
    \"model\": \"$MODEL\",
    \"prompt\": $(python3 -c "import json,sys; print(json.dumps(sys.argv[1]))" "$prompt"),
    \"stream\": false
  }")

  prompt_tok=$(echo "$result" | jq -r '.prompt_eval_count // 0')
  gen_tok=$(echo "$result" | jq -r '.eval_count // 0')
  eval_dur_ns=$(echo "$result" | jq -r '.eval_duration // 1')
  tok_per_sec=$(python3 -c "print(round($gen_tok / ($eval_dur_ns / 1e9), 2))")

  printf "%-14s %10s %10s %14s\n" "$label" "$prompt_tok" "$gen_tok" "$tok_per_sec"
done
