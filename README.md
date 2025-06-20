# Disable-ADUsersByName

A simple PowerShell script that allows you to search Active Directory users by name, select accounts by index, and optionally disable them — with interactive prompts and user confirmation.

## 🔧 Features

- Search for AD users by `Name` using partial/wildcard match (`*`).
- Automatically replaces spaces in names with wildcards (e.g., `Muhammed Ali` → `*Muhammed*Ali*`).
- Lists all matching users with numeric index.
- Prompts user to select which users to disable by entering their IDs.
- Displays selected users and asks for final confirmation before disabling.
- Fully interactive and user-safe.

## 📌 Requirements

- PowerShell 5.x or higher
- RSAT: Active Directory module installed
- AD access permissions to query and disable accounts

## 🚀 Usage

1. Clone or download this repository.
2. Open PowerShell as Administrator.
3. Run the script with a name parameter:

```powershell
.\Disable-UserByName.ps1 -Name "Muhammed Ali"

