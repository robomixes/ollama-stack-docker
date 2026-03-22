#!/bin/bash
# Pull all models listed in models.txt into the Ollama container
# Run this after: docker compose up -d

echo "Waiting for Ollama to be ready..."
until curl -s http://localhost:11434 > /dev/null 2>&1; do
  sleep 2
done
echo "Ollama is ready. Pulling models..."

while IFS= read -r model; do
  model=$(echo "$model" | xargs)  # trim whitespace
  [ -z "$model" ] && continue
  [ "${model:0:1}" = "#" ] && continue
  echo ""
  echo "==> Pulling $model..."
  docker exec ollama ollama pull "$model"
done < "$(dirname "$0")/models.txt"

echo ""
echo "Done! All models pulled."
echo "Open http://localhost:3000 to start chatting."
