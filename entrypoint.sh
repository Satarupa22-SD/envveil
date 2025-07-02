#!/bin/sh
# Decrypt secrets at container startup using passphrase from ENVVEIL_PASSPHRASE
if [ -n "$ENVVEIL_PASSPHRASE" ]; then
    envveil decrypt --passphrase "$ENVVEIL_PASSPHRASE" > .env
else
    echo "[entrypoint] ENVVEIL_PASSPHRASE not set. Skipping decryption."
fi
# Start your app (replace with your actual start command)
exec python app.py 