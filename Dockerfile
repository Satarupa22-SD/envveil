# Sample Dockerfile for using envveil to manage secrets in a container
FROM python:3.11-slim

WORKDIR /app

# Copy your application code
COPY . .

# Install your app and envveil (if not already in requirements.txt)
RUN pip install .

# Copy the encrypted secrets and key file (if using key file mode)
COPY .env.encrypted .
COPY .envveil.key .   # Only if using key file mode

# --- Key file mode: Decrypt secrets at build time (not recommended for production) ---
# RUN envveil decrypt --key .envveil.key > .env

# --- Passphrase mode: Decrypt secrets at container startup (recommended) ---
# Add an entrypoint script to decrypt secrets at runtime
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 8000

# Use the entrypoint script to decrypt and start your app
ENTRYPOINT ["./entrypoint.sh"] 