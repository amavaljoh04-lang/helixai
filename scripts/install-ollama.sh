#!/usr/bin/env bash
# HelixAI — Auto-install Ollama if not present
set -euo pipefail

OLLAMA_MIN_VERSION="0.1.16"

check_ollama() {
    if command -v ollama &>/dev/null; then
        CURRENT=$(ollama --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
        if [ -n "$CURRENT" ]; then
            echo "[HelixAI] Ollama $CURRENT is already installed."
            return 0
        fi
    fi
    return 1
}

install_ollama() {
    echo "[HelixAI] Ollama not found. Installing..."

    # Detect OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)

    case "$ARCH" in
        x86_64)  ARCH="amd64" ;;
        aarch64) ARCH="arm64" ;;
        arm64)   ARCH="arm64" ;;
        *)
            echo "[HelixAI] Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    if [ "$OS" = "linux" ]; then
        echo "[HelixAI] Downloading Ollama for Linux ($ARCH)..."
        curl -fsSL https://ollama.com/install.sh | sh
    elif [ "$OS" = "darwin" ]; then
        echo "[HelixAI] On macOS, please install Ollama from https://ollama.com/download"
        echo "[HelixAI] Or run: brew install ollama"
        exit 1
    else
        echo "[HelixAI] Unsupported OS: $OS"
        echo "[HelixAI] Please install Ollama manually from https://ollama.com"
        exit 1
    fi

    # Verify installation
    if command -v ollama &>/dev/null; then
        echo "[HelixAI] Ollama installed successfully!"
        ollama --version 2>/dev/null || true
    else
        echo "[HelixAI] ERROR: Ollama installation failed."
        exit 1
    fi
}

start_ollama() {
    if pgrep -x "ollama" &>/dev/null; then
        echo "[HelixAI] Ollama is already running."
        return 0
    fi

    echo "[HelixAI] Starting Ollama server..."

    # Try systemd first
    if command -v systemctl &>/dev/null; then
        sudo systemctl start ollama 2>/dev/null && {
            echo "[HelixAI] Ollama started via systemd."
            return 0
        }
    fi

    # Fallback: start in background
    nohup ollama serve &>/dev/null &
    sleep 2

    if pgrep -x "ollama" &>/dev/null; then
        echo "[HelixAI] Ollama started in background."
    else
        echo "[HelixAI] WARNING: Could not start Ollama automatically."
        echo "[HelixAI] Please run 'ollama serve' manually."
    fi
}

pull_default_models() {
    local models=("${@}")
    if [ ${#models[@]} -eq 0 ]; then
        echo "[HelixAI] No default models specified. Skipping pull."
        return 0
    fi

    for model in "${models[@]}"; do
        echo "[HelixAI] Pulling model: $model ..."
        ollama pull "$model" || echo "[HelixAI] WARNING: Failed to pull $model"
    done
}

# Main
echo "============================================"
echo "  HelixAI — Ollama Auto-Setup"
echo "============================================"
echo ""

if ! check_ollama; then
    install_ollama
fi

start_ollama

# Pull default models if HELIXAI_DEFAULT_MODELS env var is set
# Example: HELIXAI_DEFAULT_MODELS="llama3:8b,codellama:7b"
if [ -n "${HELIXAI_DEFAULT_MODELS:-}" ]; then
    IFS=',' read -ra MODELS <<< "$HELIXAI_DEFAULT_MODELS"
    pull_default_models "${MODELS[@]}"
fi

echo ""
echo "[HelixAI] Setup complete! Ollama is ready."
echo "[HelixAI] Access HelixAI at http://localhost:8080"
