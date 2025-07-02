# Deploying Applications Securely with envveil

This guide explains, in simple steps, how to use envveil to keep your secrets safe when deploying your application to production, a server, or the cloud.

---

## 1. Why Use envveil?
- **Never commit your real secrets (API keys, passwords, etc.) to GitHub!**
- envveil helps you encrypt your secrets so only you (or your deployment process) can decrypt them.
- Only the encrypted secrets are stored in your code repository.

---

## 2. Encrypt Your Secrets (Before Pushing to GitHub)

1. **Create a `.env` file** with your secrets:
   ```env
   SECRET_KEY=your_secret_key
   API_KEY=your_api_key
   DB_PASSWORD=your_db_password
   ```

2. **Encrypt the secrets with envveil:**
   ```sh
   envveil encrypt --env .env --passphrase "your_passphrase"
   ```
   - This creates `.env.encrypted` (and optionally `.envveil.key` if using key file mode).
   - Only commit `.env.encrypted` to your repository. **Never commit `.env` or `.envveil.key`.**

---

## 3. Commit and Push
- Add `.env.encrypted` to your repository.
- Make sure `.env` and `.envveil.key` are in your `.gitignore` (envveil does this automatically).
- Push your code to GitHub or your remote repository.

---

## 4. Decrypt Secrets During Deployment

When you deploy your app (on a server, in CI/CD, or in Docker), you need to decrypt the secrets so your app can use them.

### **A. On a Server or in CI/CD**
1. **Set the passphrase as an environment variable (never hardcode it!):**
   ```sh
   export ENVVEIL_PASSPHRASE=your_passphrase
   ```
2. **Decrypt the secrets before starting your app:**
   ```sh
   envveil decrypt --passphrase "$ENVVEIL_PASSPHRASE" > .env
   ```
3. **Start your app as usual.**

### **B. In Docker**
1. **Add the encrypted secrets and entrypoint script to your Docker image.**
2. **Build and run your Docker container:**
   ```sh
   docker build -t myappimage .
   docker run -e ENVVEIL_PASSPHRASE=your_passphrase myappimage
   ```
   - The entrypoint script will decrypt the secrets and start your app.

---

## 5. Best Practices
- **Never commit decrypted secrets or passphrases to your repository.**
- **Store your passphrase in a secure place** (CI/CD secret manager, cloud secret manager, etc.).
- **Rotate your passphrase or key regularly** using envveil's rotate-key command.
- **Check the audit log** (`envveil_audit.log`) to see when secrets were accessed or rotated.

---

## 6. Example Workflow

```sh
# Encrypt secrets before pushing code
envveil encrypt --env .env --passphrase "mysecretpass"
git add .env.encrypted .gitignore
# (do NOT add .env or .envveil.key)
git commit -m "Add encrypted secrets"
git push

# On the server or in CI/CD
export ENVVEIL_PASSPHRASE=mysecretpass
envveil decrypt --passphrase "$ENVVEIL_PASSPHRASE" > .env
python app.py  # or your app's start command
```

---

**envveil makes it easy to keep your secrets safe, even when your code is public!** 