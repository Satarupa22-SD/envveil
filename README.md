# Envveil

**Envveil** is a Python library and CLI tool for scanning, encrypting, and managing sensitive secrets (like API keys, tokens, and passwords) in your project. It helps you keep secrets out of your codebase, supports both key file and passphrase-based encryption, and provides audit logging and .gitignore management for maximum security.

---

## Author

- **Satarupa Deb**  
---

## Features

- **Scan** for sensitive keys in `.env`, `settings.py`, JSON, and other files
- **Encrypt** secrets using either a key file or a user-supplied passphrase (no key file needed)
- **Decrypt** secrets easily for local use
- **Rotate** encryption keys or passphrases and re-encrypt secrets
- **Retrofit** protection for already-pushed repositories
- **Audit logging** for all secret access and key rotation events
- **Automatic .gitignore management** and warnings for unsafe key handling
- **Language-specific .gitignore template fetcher**

---

## Installation

### From PyPI

```sh
pip install envveil
```
---

## Usage Summary Table

| Step         | Command Example                                      | What Happens                                              |
|--------------|------------------------------------------------------|-----------------------------------------------------------|
| Scan         | `scan --env .env`                                    | Finds secrets in file                                     |
| Encrypt      | `encrypt --env .env --passphrase "your_passphrase"`  | Encrypts secrets with passphrase, stores salt+data        |
| Decrypt      | `decrypt --passphrase "your_passphrase"`             | Decrypts and prints secrets                               |
| Rotate Key   | `rotate-key --old-passphrase "old" --new-passphrase "new"` | Changes passphrase, re-encrypts secrets             |
| Audit Log    | (automatic)                                          | Logs all decrypt/rotate events                            |
| .gitignore   | (automatic)                                          | Ensures secret files are ignored by git                   |

---

## Security Notes

- **Passphrase mode:** No key file is stored. The passphrase is never saved; if you forget it, secrets are unrecoverable.
- **Key file mode:** Always ensure `.envveil.key` is in your `.gitignore`. envveil will warn you if not.
- **Audit log:** All decryption and key rotation events are logged in `envveil_audit.log`.
- **.env.encrypted** and key files are always added to `.gitignore` automatically.

---

## License

MIT License

---

## Disclaimer

envveil is a developer tool for secret management and does not guarantee absolute security. Always follow best practices for secret storage and access control in production environments. 
