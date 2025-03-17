# Termux Login Security Script 🔒

## About
**Termux-Login** is a security script for Termux that adds an authentication layer before granting access to the Termux shell. The script prompts the user for fingerprint authentication up to three times and, upon failure, requests a password. If authentication fails, it logs the attempt and takes photos of the intruder using the device's cameras.

## Features
- **Fingerprint authentication** (via `termux-fingerprint`)
- **Password authentication** (SHA-256 hash comparison)
- **Intruder detection**
  - Logs unauthorized login attempts
  - Captures photos from both front and back cameras
  - Sends a notification alert
- **Automatic logging** of login attempts
- **Security notifications** with vibration and sound alerts

> [!WARNING]
> The script may not function properly (e.g., fail to take photos) on devices without a front camera.

![screenshot](/img1.jpg)

## Installation
### Prerequisites
Ensure you have Termux and Termux API installed:
```sh
pkg update && pkg upgrade
pkg install termux-api
termux-api-start
```

> [!CAUTION]
> Termux API is required for this script to function properly. Without a properly installed and configured Termux API, the script **will not work and will lock Termux**.

You can download Termux API from F-Droid:
[click here](https://f-droid.org/en/packages/com.termux.api/)

> [!NOTE]
> Both applications (Termux and Termux:API) must come from the same source.

### Download and Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/BuriXon-code/termux-login.git
   ```
2. Move the script to the required location:
   ```sh
   mv termux-login/termux-login.sh $PREFIX/etc/termux-login.sh
   ```
3. Grant execution permission:
   ```sh
   chmod +x $PREFIX/etc/termux-login.sh
   ```
4. Set up the expected SHA-256 password:
   - Generate the SHA-256 hash of your password:
     ```sh
     echo -n "your_password" | sha256sum
     ```
   - Edit `termux-login.sh` and replace `password-sha256` with the generated hash.

## Usage
Once installed, the script will execute automatically when Termux starts.

### Authentication Flow
1. The script prompts for fingerprint authentication (max 3 attempts).
2. If fingerprint authentication fails, it requests a password.
3. Upon failed authentication:
   - Logs the failed attempt
   - Captures photos of the intruder
   - Sends a high-priority notification alert
   - Kills the Termux process to prevent unauthorized access

![screenshot](/img2.jpg)

### Log Files
Logs are stored in:
```
/data/data/com.termux/files/home/.login_logs/logs.txt
```
Intruder photos are stored in:
```
/data/data/com.termux/files/home/.login_logs/intruders/
```

![screenshot](/img3.jpg)

## Support
### Contact me:
For any issues, suggestions, or questions, reach out via:

- **Email:** support@burixon.com.pl  
- **Contact form:** [Click here](https://burixon.com.pl/kontakt.php)

### Support me:
If you find this script useful, consider supporting my work by making a donation:

[**DONATE HERE**](https://burixon.com.pl/donate/)

Your contributions help in developing new projects and improving existing tools!
