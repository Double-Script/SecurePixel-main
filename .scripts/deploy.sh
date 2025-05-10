#!/bin/bash
set -e

PROJECT_ROOT="/home/ubuntu/SecurePixel-main"
VENV_PATH="$PROJECT_ROOT/secp"
MANAGE="$PROJECT_ROOT/SecurePixel/manage.py"

echo "Deployment started ..."

# Navigate to the project directory
cd "$PROJECT_ROOT"

# Pull the latest version of the app
echo "Copying New changes...."
git pull origin main
echo "New changes copied to server !"

# Activate Virtual Env
source "$VENV_PATH/bin/activate"
echo "Virtual env 'secp' Activated !"

# Clear Python bytecode cache
echo "Clearing Python bytecode cache (.pyc)..."
find "$PROJECT_ROOT" -name "*.pyc" -delete

echo "Installing Dependencies..."
pip install -r "$PROJECT_ROOT/requirements.txt" --no-input

echo "Serving Static Files..."
python3 "$MANAGE" collectstatic --noinput

echo "Running Database migration..."
python3 "$MANAGE" makemigrations
python3 "$MANAGE" migrate

# Deactivate Virtual Env
deactivate
echo "Virtual env 'secp' Deactivated !"

echo "Reloading App..."
ps aux | grep gunicorn | grep SecurePixel/SecurePixel | awk '{ print $2 }' | xargs kill -HUP

echo "Deployment Finished !"
