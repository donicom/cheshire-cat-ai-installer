#!/bin/bash

set -e  # Exit on first error
echo "🚀 Starting installation of dependencies on the host system..."

echo "📥 Cloning Cheshire Cat Core repository..."
git clone https://github.com/cheshire-cat-ai/core.git
cd core/core

echo "🛠️ Updating system and installing base packages..."
sudo apt-get update
sudo apt-get install -y curl build-essential fastjar libmagic-mgc libmagic1 mime-support python3.10 python3.10-venv python3-pip

echo "📥 Installing Admin Panel"
mkdir /admin
cd /admin
curl -sL https://github.com/cheshire-cat-ai/admin-vue/releases/download/Admin/release.zip | jar -xv
cd -
cd core

echo "🐍 Creating Python virtual environment..."
python3.11 -m venv venv

echo "✅ Activating virtual environment..."
source venv/bin/activate

echo "📦 Upgrading pip..."
pip install --upgrade pip

echo "🔧 Installing project Python dependencies..."
pip install --no-cache-dir .

echo "📚 Downloading NLTK models and initializing tiktoken..."
python3.11 -c "import nltk; nltk.download('punkt'); nltk.download('averaged_perceptron_tagger'); import tiktoken; tiktoken.get_encoding('cl100k_base')"

echo "🔌 Installing plugin dependencies via script..."
python3.11 install_plugin_dependencies.py

echo "✅ Setup complete. Launching the program..."
python3.11 -m cat.main
