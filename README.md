# Ollama Stack Docker

**Run powerful AI models locally with a ChatGPT-like interface. Private, offline, and portable.**

One command to deploy [Ollama](https://ollama.com/) + [Open WebUI](https://openwebui.com/) with GPU support, RAG (chat with your documents), and 12 pre-configured models covering general chat, coding, medical, vision, multilingual, and more.

---

## Features

- **Private & Offline** — Everything runs locally. No data leaves your machine.
- **Chat with Documents (RAG)** — Upload PDFs, DOCX, TXT, CSV files and ask questions about them.
- **12 Pre-configured Models** — General, coding, medical, reasoning, vision, multilingual, and math.
- **GPU Accelerated** — Automatic NVIDIA GPU detection. Falls back to CPU seamlessly.
- **Portable** — Copy the folder to any machine with Docker. One command to start.
- **Web Interface** — Beautiful ChatGPT-like UI accessible at `http://localhost:3000`.
- **Multi-user** — Create accounts, share models, manage access.
- **Arena Mode** — Compare multiple models side-by-side on the same prompt.
- **Knowledge Collections** — Organize documents into domain-specific collections for focused AI assistants.

---

## Quick Start

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- At least **16 GB RAM** (32 GB recommended)
- **NVIDIA GPU** optional but recommended for faster inference

### 1. Clone and Start

```bash
git clone https://github.com/robomixes/ollama-stack-docker.git
cd ollama-stack-docker
docker compose up -d
```

### 2. Pull Models

```bash
bash setup-models.sh
```

This pulls all models listed in `models.txt` (~40 GB total). Takes 30-60 minutes depending on your internet speed.

### 3. Open the UI

Go to **http://localhost:3000** and create your admin account (first registration = admin).

---

## Included Models

| Model | Size | Domain | Best For |
|-------|------|--------|----------|
| `llama3.2:3b` | 2.0 GB | General | Fast GPU chat |
| `llama3.1:8b` | 4.9 GB | General | Best quality general purpose |
| `mistral:7b` | 4.4 GB | General | Good all-rounder |
| `gemma2:2b` | 1.6 GB | General | Lightweight, fastest |
| `deepseek-r1:8b` | 5.2 GB | Reasoning | Chain-of-thought (shows thinking process) |
| `phi3.5:3.8b` | 2.2 GB | Reasoning | Strong reasoning, fits 4GB GPU |
| `qwen2.5-coder:7b` | 4.7 GB | Coding | Best open-source coding model |
| `meditron:7b` | 4.1 GB | Medical | Clinical guidelines, medical Q&A |
| `aya:8b` | 4.8 GB | Multilingual | 23 languages including Arabic |
| `llava:7b` | 4.5 GB | Vision | Describe/analyze uploaded images |
| `qwen2.5:7b` | 4.7 GB | Math/Science | Math, science, structured tasks |
| `nomic-embed-text` | 274 MB | Embeddings | Required for RAG/document chat |

### Add or Remove Models

Edit `models.txt` and re-run:

```bash
bash setup-models.sh
```

Browse all available models at [ollama.com/library](https://ollama.com/library).

---

## Chat with Documents (RAG)

Open WebUI includes built-in RAG (Retrieval-Augmented Generation) for chatting with your own documents.

### Quick Upload

1. Open any chat
2. Click the **+** button in the message input
3. Upload a PDF, TXT, DOCX, CSV, or Markdown file
4. Ask questions about the document

### Knowledge Collections

For organizing multiple documents into a domain-specific knowledge base:

1. Go to **Workspace** > **Knowledge**
2. Click **+ Create Knowledge**
3. Name it (e.g., "Medical Research", "Legal Docs", "Company Wiki")
4. Upload multiple files
5. In any chat, type **#** to attach a knowledge collection

### RAG Settings

Default settings work well. To customize, go to **Admin Panel** > **Settings** > **Documents**:

| Setting | Default | Description |
|---------|---------|-------------|
| Embedding Engine | Ollama | Uses local Ollama for embeddings |
| Embedding Model | nomic-embed-text | Fast, accurate embeddings |
| Chunk Size | 1000 | Characters per chunk |
| Chunk Overlap | 100 | Overlap between chunks |

---

## Create Domain-Specific Bots

Build specialized AI assistants by combining a model with a knowledge collection:

1. Go to **Workspace** > **Models**
2. Click **+ Create a Model**
3. Configure:
   - **Name**: e.g., "Medical Assistant"
   - **Base Model**: Choose the most appropriate model
   - **Knowledge**: Attach your document collection
   - **System Prompt**: Define the bot's behavior

### Example: Medical Bot

```
Base Model: meditron:7b
Knowledge: Your medical textbooks and guidelines
System Prompt: You are a medical knowledge assistant. Answer based on the
provided documents. Always note when information should be verified by a
healthcare professional.
```

### Example: Coding Assistant

```
Base Model: qwen2.5-coder:7b
Knowledge: Your codebase documentation and API docs
System Prompt: You are a senior software engineer. Help with code reviews,
debugging, and implementation. Reference the provided documentation when relevant.
```

### Example: Geopolitical Analyst

```
Base Model: deepseek-r1:8b
Knowledge: Think tank reports, foreign policy journals, country profiles
System Prompt: You are a geopolitical analyst. Analyze questions considering
multiple perspectives, historical context, and power dynamics. Distinguish
facts from assessments.
```

---

## Architecture

```
Browser ──→ Open WebUI (port 3000) ──→ Ollama (port 11434)
                │                           │
                │                      GPU/CPU inference
                │
            RAG Pipeline
            (ChromaDB + nomic-embed-text)
```

Both services run as Docker containers on a shared network. Data persists in Docker volumes.

---

## GPU Support

| Platform | Setup | Notes |
|----------|-------|-------|
| **Windows** | Automatic | Docker Desktop + WSL2 detects NVIDIA GPU |
| **Linux** | Install [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) | Then `docker compose up -d` |
| **Mac (Apple Silicon)** | Automatic | Uses Metal acceleration via Ollama |
| **No GPU** | No changes needed | Runs on CPU, slower but works |

### GPU VRAM Guide

| VRAM | Recommended Models |
|------|--------------------|
| 4 GB | `llama3.2:3b`, `phi3.5:3.8b`, `gemma2:2b` |
| 8 GB | Above + `mistral:7b`, `llama3.1:8b` |
| 16 GB | Above + `deepseek-r1:14b`, any 7B model fully in VRAM |
| 24 GB+ | Any model up to 70B parameters |

Models that don't fit in VRAM automatically offload layers to CPU (hybrid mode).

---

## Hardware Requirements

| Spec | Minimum | Recommended |
|------|---------|-------------|
| RAM | 8 GB | 32 GB |
| Storage | 20 GB | 60 GB+ |
| GPU | None (CPU works) | NVIDIA with 4GB+ VRAM |
| CPU | 4 cores | 8+ cores |
| OS | Any with Docker | Windows 11, Ubuntu 22.04+, macOS |

---

## Deploy to Cloud

This stack runs anywhere Docker runs. Copy the folder and start.

### Azure VM (GPU)

```bash
# Create NC-series VM (GPU), SSH in, then:
sudo apt update && sudo apt install -y docker.io nvidia-container-toolkit
sudo systemctl restart docker
git clone https://github.com/robomixes/ollama-stack-docker.git
cd ollama-stack-docker
docker compose up -d
bash setup-models.sh
# Access at http://<VM-IP>:3000
```

### Any Linux Server

```bash
git clone https://github.com/robomixes/ollama-stack-docker.git
cd ollama-stack-docker
docker compose up -d
bash setup-models.sh
```

---

## Commands Reference

```bash
# Start the stack
docker compose up -d

# Stop the stack
docker compose down

# View running containers
docker compose ps

# Pull/update models
bash setup-models.sh

# Pull a specific model manually
docker exec ollama ollama pull <model-name>

# List installed models
docker exec ollama ollama list

# Test a model
docker exec ollama ollama run llama3.2:3b "Hello!"

# View Ollama logs
docker logs ollama

# View Open WebUI logs
docker logs open-webui

# Check GPU usage
nvidia-smi

# Update images to latest
docker compose pull && docker compose up -d
```

---

## File Structure

```
ollama-stack-docker/
├── docker-compose.yml   # Service definitions (Ollama + Open WebUI)
├── models.txt           # Configurable list of models to pull
├── setup-models.sh      # Script to pull all models from models.txt
├── .env.example         # Environment variables template
├── .gitignore           # Excludes exports and secrets
└── README.md            # This file
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No models in Open WebUI | Wait for `setup-models.sh` to finish. Check `docker logs ollama` |
| "Connection refused" | Ensure Ollama container is running: `docker compose ps` |
| GPU not detected | Windows: update Docker Desktop. Linux: install `nvidia-container-toolkit` |
| Out of VRAM | Use smaller models (`gemma2:2b`, `llama3.2:3b`) or let it offload to CPU |
| Slow responses | Normal on CPU. Use GPU models (3B-4B) for speed |
| Port 3000 in use | Change port in `docker-compose.yml`: `"3001:8080"` |
| Models lost after restart | Check volumes: `docker volume ls`. Should persist automatically |
| Upload fails (large PDF) | Split into smaller files. Increase chunk size in Admin > Settings > Documents |

---

## License

This is a configuration stack using open-source components:
- [Ollama](https://github.com/ollama/ollama) — MIT License
- [Open WebUI](https://github.com/open-webui/open-webui) — MIT License
- Models have their own licenses — check each model's page on [ollama.com/library](https://ollama.com/library)
