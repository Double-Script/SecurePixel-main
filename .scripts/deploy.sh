#!/bin/bash
set -e


echo "Deployment started ..."

# Pull the latest version of the app
echo "Copying New changes...."
git pull origin main
echo "New changes copied to server !"

# Activate Virtual Env
#Syntax:- source virtual_env_name/bin/activate
source /home/ubuntu/SecurePixel-main/secp/bin/activate

echo "Virtual env 'secp' Activated !"

echo "Clearing Cache..."
# python3 manage.py clean_pyc
# python3 manage.py clear_cache

echo "Installing Dependencies..."
pip install -r /home/ubuntu/SecurePixel-main/requirements.txt --no-input

echo "Serving Static Files..."
python3 "/home/ubuntu/SecurePixel-main/SecurePixel/" manage.py collectstatic --noinput

echo "Running Database migration..."
python3 "/home/ubuntu/SecurePixel-main/SecurePixel/" manage.py makemigrations
python3 "/home/ubuntu/SecurePixel-main/SecurePixel/" manage.py migrate

# Deactivate Virtual Env
deactivate
echo "Virtual env 'secp' Deactivated !"

echo "Reloading App..."

GUNICORN_PID=$(ps aux | grep gunicorn | grep SecurePixel/SecurePixel | grep -v grep | awk '{ print $2 }')

if [ -z "$GUNICORN_PID" ]; then
    echo "Gunicorn process not found. Starting a new instance..."
    # Optional: Start gunicorn manually if needed
    # Example:
    # nohup gunicorn SecurePixel.wsgi:application --bind 0.0.0.0:8000 --daemon --chdir /home/ubuntu/SecurePixel-main/SecurePixel/ --pid /tmp/gunicorn.pid
else
    echo "Sending HUP to Gunicorn PID: $GUNICORN_PID"
    kill -HUP "$GUNICORN_PID"
fi
