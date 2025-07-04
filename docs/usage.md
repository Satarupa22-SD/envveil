# envveil Usage Guide

This guide explains how to use envveil to scan, encrypt, decrypt, rotate, and manage secrets in your project.

---

## 1. Scan for Secrets

Scan a single file (default: .env):
```sh
envveil scan --env .env
```

Scan multiple files using patterns:
```sh
envveil scanall --pattern "*.py" --pattern "config/*.json"
```

---

## 1a. Scan the Entire Repository (scanrepo)

Scan all supported files in your entire project directory (recursively):
```sh
envveil scanrepo --dir .
```

Scan a specific subfolder (e.g., demo):
```sh
envveil scanrepo --dir demo
```

Scan an absolute path:
```sh
envveil scanrepo --dir /path/to/your/project/demo
```

- This will recursively scan all supported file types, including `.env`, `.py`, `.js`, `.jsx`, `.ts`, `.tsx`, `.json`, `.yaml`, `.yml`, `.toml`, `.ini`, `.cfg`, `.conf`, and more.
- Any secrets matching your `secret_patterns.txt` will be reported, regardless of where they are stored.

---

## 2. Add .env to .gitignore Without Encrypting (storeenv)

If you just want to make sure your `.env` file (or any secret file) is not committed to git, but don't want to encrypt it, use:

```sh
envveil storeenv --env .env
```
- This will add `.env` to your `.gitignore` if it's not already there.
- You can specify a different file with `--env <filename>`.

---

## 3. Encrypt Secrets

### With Key File (default)
```sh
envveil encrypt --env .env
```
- Generates a key file (.envveil.key) if not present.
- Encrypts secrets and stores them in .env.encrypted.
- Ensures both files are in .gitignore.

### With Passphrase
```sh
envveil encrypt --env .env --passphrase "your_passphrase"
```
- No key file is created or needed.
- You must remember your passphrase to decrypt.

---

## 4. Decrypt Secrets

With passphrase:
```sh
envveil decrypt --passphrase "your_passphrase"
```

With key file:
```sh
envveil decrypt --key path/to/keyfile
```

If neither is provided, you will be prompted.

---

## 5. Rotate Key or Passphrase

Change the passphrase:
```sh
envveil rotate-key --old-passphrase "old" --new-passphrase "new"
```

Change the key file:
```sh
envveil rotate-key --old-key oldkeyfile.key --new-key newkeyfile.key
```

---

## 6. Retrofit for Existing Repos

Encrypt secrets in a repo that is already public:
```sh
envveil retrofit --env .env
```
- Scans for secrets, encrypts them, and ensures .gitignore is set up.

---

## 7. Fetch Language-Specific .gitignore

Fetch and update .gitignore for your language:
```sh
envveil gitignore python
envveil gitignore node
```
- Fetches the latest template from GitHub's official gitignore repo.
- Ensures secret files are ignored.

**To replace the current .gitignore with a new language template (e.g., replace Node.js rules with Python rules):**
```sh
envveil gitignore python --replace
```
- This will overwrite your .gitignore with only the Python template and secret file ignores.
- Use `--replace` any time you want to fully switch the ignore rules to a new language.

---

## 8. Audit Logging

- All decryption and key rotation events are logged in `envveil_audit.log` with timestamp, user, action, and file.

---

## 9. Security Notes

- **Passphrase mode:** No key file is stored. The passphrase is never saved; if you forget it, secrets are unrecoverable.
- **Key file mode:** Always ensure `.envveil.key` is in your `.gitignore`. envveil will warn you if not.
- **.env.encrypted** and key files are always added to `.gitignore` automatically.

---

## 10. Automating Decryption in Deployment (CI/CD, Servers)

Before starting your app in production or CI/CD, decrypt secrets and write them to a .env file:

```sh
# Example in a deployment script or CI/CD pipeline
envveil decrypt --passphrase "$DEPLOY_SECRET" > .env
```
- Your app then loads secrets from `.env` as usual.
- Never commit the decrypted `.env` file to your repository.

---

## 11. Using envveil with Docker or Cloud Platforms

**Docker:**
- Add a step in your Dockerfile or entrypoint script to decrypt before starting the app:

```dockerfile
# Dockerfile example
COPY .env.encrypted ./
COPY envveil.key ./
RUN envveil decrypt --key envveil.key > .env
```

**Passphrase mode (recommended):**
- Use an entrypoint script and pass the passphrase as an environment variable:

```sh
docker build -t myappimage .
docker run -e ENVVEIL_PASSPHRASE=yourpassphrase myappimage
```

**Cloud (Heroku, AWS, etc.):**
- Use the decrypted output to set environment variables via the platform's secret management, or decrypt to a `.env` file as part of your deployment process.

---

## 12. Example Workflow

```sh
# Scan for secrets
envveil scanall --pattern "*.env" --pattern "settings.py"

# Encrypt secrets with a passphrase
envveil encrypt --env .env --passphrase "mysecretpass"

# Decrypt secrets
envveil decrypt --passphrase "mysecretpass"

# Rotate to a new passphrase
envveil rotate-key --old-passphrase "mysecretpass" --new-passphrase "newpass"

# Check audit log
type envveil_audit.log
```

---

> **Note:**
> If the `envveil` command is not found, you can always use:
> `python -m envveil.cli ...` 