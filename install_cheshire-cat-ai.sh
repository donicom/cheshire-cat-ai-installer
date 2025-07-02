#!/bin/bash

set -e  # Exit on first error
echo "🚀 Starting installation of dependencies on the host system..."

# 0. Clone the core repository
echo "📥 Cloning Cheshire Cat Core repository..."
git clone https://github.com/cheshire-cat-ai/core.git
cd core

# 1. System update and install required packages
sudo apt-get update
sudo apt-get install -y curl build-essential fastjar libmagic-mgc libmagic1 mime-support python3.10 python3.10-venv python3-pip

# 2. Upgrade pip
python3.10 -m pip install --upgrade pip

# 3. Prepare the /app directory (we assume you're in the project root)
cd "$(dirname "$0")"
mkdir -p /app
cp pyproject.toml /app/
cp -r cat /app/
cp install_plugin_dependencies.py /app/

# 4. Install Python project dependencies
cd /app
pip install --no-cache-dir .

# 5. Download NLTK resources and initialize tiktoken
python3.10 -c "import nltk; nltk.download('punkt'); nltk.download('averaged_perceptron_tagger'); import tiktoken; tiktoken.get_encoding('cl100k_base')"

# 6. Install plugin dependencies
python3.10 install_plugin_dependencies.py

# 7. Launch the application
echo "✅ Setup complete. Launching the program..."
python3.10 -m cat.main
