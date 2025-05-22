# Disable DNS over HTTPS (DoH) via Group Policy Script

This project provides a PowerShell script designed for deployment via Active Directory Group Policy to **disable DNS over HTTPS (DoH)** across all major web browsers:

- Google Chrome
- Microsoft Edge
- Mozilla Firefox
- Opera

## 🔧 Features

- Enforces GPO registry settings for Chrome and Edge
- Deploys `policies.json` for Firefox Enterprise Policy support
- Cleans up DoH flags from Opera browser shortcut (if installed)
- Logs script execution to the Windows Event Log

## 📂 Deployment Instructions

### 1. Add to GPO

- Place `Disable-DoH.ps1` in `\\<domain>\SYSVOL\<domain>\Scripts\Disable-DoH.ps1`
- Open Group Policy Management Console
- Navigate to:
  ```
  Computer Configuration > Policies > Windows Settings > Scripts > Startup
  ```
- Add the PowerShell script

### 2. Apply the GPO to your target OU

### 3. Reboot or run `gpupdate /force` on clients

## 📸 Screenshots

See [`docs/screenshots.md`](docs/screenshots.md)

## ✅ Tested On

- Windows 10/11
- Chrome v120+
- Edge v120+
- Firefox ESR & Standard
- Opera v105+

## 🔒 License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
