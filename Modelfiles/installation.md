# Create the Modelfile
cat > ~/Modelfiles/gemma4-coding << 'EOF'
FROM gemma4:27b

PARAMETER num_ctx 32768
PARAMETER temperature 0.7
PARAMETER num_predict 4096
EOF

# Build and use it
ollama create gemma4-coding -f ~/Modelfiles/gemma4-coding
ollama run gemma4-coding
