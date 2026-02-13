# MyTerminalKit

Set up a beautiful, productive terminal environment in one command. Clone the repo, run the installer, answer a few questions — done.

Works on **macOS** and **Linux** (Debian/Ubuntu, Fedora/RHEL, Arch, openSUSE, Alpine).

## Quick Start

```bash
git clone https://github.com/diveaire/MyTerminalKit.git
cd MyTerminalKit
chmod +x install.sh
./install.sh
```

The installer is **interactive**: it detects your OS and package manager automatically, then asks which components you want to install.

## What Can Be Installed

| Component         | Description                                    |
| ----------------- | ---------------------------------------------- |
| **Zsh**           | Modern shell replacing bash                    |
| **Oh My Zsh**     | Zsh framework with themes & plugins            |
| **Powerlevel10k** | Fast, highly customizable Zsh theme            |
| **Zsh plugins**   | autosuggestions + syntax-highlighting          |
| **colorls**       | `ls` replacement with colors & file-type icons |
| **Neovim**        | Terminal-based code editor                     |
| **LazyVim**       | Full IDE layer for Neovim (lazy.nvim based)    |
| **Shell config**  | Pre-configured `.zshrc` and `.p10k.zsh`        |

## Font Installation (Local Only)

Nerd Fonts are needed on the machine **running your terminal emulator**, not on remote servers you SSH into. A separate script handles this:

```bash
chmod +x installFont.sh
./installFont.sh
```

Bundled fonts (in `fonts/`): FiraCode, FiraMono, Hack, Meslo.

After installing, select the Nerd Font in your terminal emulator settings (iTerm2, Windows Terminal, GNOME Terminal, etc.).

## Customization

After installation you can:

- **Edit your Zsh config** — `~/.zshrc` (or run the alias `zshconfig`)
- **Reconfigure Powerlevel10k** — run `p10k configure`
- **Edit Powerlevel10k config** — `~/.p10k.zsh` (or alias `p10kconfig`)
- **Update Powerlevel10k** — run the alias `zshupdate`
- **Reload shell** — `exec zsh` (or alias `src`)

## Supported Platforms

| OS              | Package Manager                      |
| --------------- | ------------------------------------ |
| macOS           | Homebrew (auto-installed if missing) |
| Debian / Ubuntu | apt                                  |
| Fedora / RHEL   | dnf / yum                            |
| Arch Linux      | pacman                               |
| openSUSE        | zypper                               |
| Alpine          | apk                                  |

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

## License

Distributed under the MIT License. See `LICENSE` for details.

---

# Maintainer Guide

## Project Structure

```
MyTerminalKit/
├── install.sh            # Main interactive installer (entry point)
├── installFont.sh        # Nerd Fonts installer (local machines only)
├── scripts/
│   ├── utils.sh          # Shared utilities (colors, OS detection, pkg_install, helpers)
│   ├── tools.sh          # Prerequisites & extra tools (curl, git, homebrew, colorls)
│   ├── zsh.sh            # Zsh, Oh My Zsh, Powerlevel10k, plugins, config deployment
│   └── neovim.sh         # Neovim, LazyVim dependencies, LazyVim starter
├── configs/
│   ├── .zshrc            # Unified Zsh config (works on macOS & Linux)
│   └── .p10k.zsh         # Default Powerlevel10k config
├── fonts/                # Nerd Font .zip archives
│   ├── FiraCode.zip
│   ├── FiraMono.zip
│   ├── Hack.zip
│   └── Meslo.zip
├── linux/                # (legacy) old per-OS configs — kept for reference
├── macOs/                # (legacy) old per-OS configs — kept for reference
└── README.md
```

## Architecture

- **`install.sh`** is the only entry point. It sources the four modules from `scripts/` and orchestrates the interactive flow.
- **`scripts/utils.sh`** provides OS detection, package-manager abstraction (`pkg_install`, `pkg_update`), colored output helpers, and `ask_yes_no`.
- Each module (`zsh.sh`, `neovim.sh`, `tools.sh`) exposes self-contained functions. They rely on the variables and helpers defined in `utils.sh`.
- The installer **never spawns a new shell session** mid-script (Oh My Zsh is installed with `RUNZSH=no CHSH=no --unattended`).
- LazyVim is installed using the **official starter template** (not the LazyVim repo directly) and uses `nvim --headless "+Lazy! sync" +qa` to bootstrap plugins.

## Adding a New Component

1. Create a function in the appropriate `scripts/*.sh` module (or create a new module).
2. Source the new module in `install.sh` if needed.
3. Add a question in the **Component Selection** section of `install.sh`.
4. Add the install call in the **Installation** section.
5. Add a summary line in the **Summary** section.
6. Update this README.

## Key Design Decisions

- **Interactive by default** — every component is opt-in via Y/n prompts.
- **Idempotent** — re-running the installer skips already-installed components.
- **Config backups** — existing `.zshrc` / `.p10k.zsh` / nvim configs are backed up with timestamps before overwriting.
- **No OS-specific config files** — a single unified `.zshrc` in `configs/` works on all platforms. The old `linux/` and `macOs/` directories are kept for reference but are no longer used by the installer.
