# My HyDE Dotfiles

**My CachyOS + Hyprland desktop, ready to install.**
HyDE on a bare CachyOS install (no desktop environment), plus my own keybindings, bar, theme and terminal config.

![Desktop](docs/screenshot.png)

## What you get

<!-- Fill these in with your own highlights. Examples: -->
- **Bar.** Waybar layout: *describe yours*
- **Launcher and menus.** Rofi and wlogout styling: *describe yours*
- **Theme.** *Theme name* by *author*. Install with `hyde-shell theme import` (see Themes)
- **Terminal.** Kitty and fastfetch setup: *describe yours*
- **Keybindings.** *anything non-default worth mentioning*

## What's in here

| Path | What it is |
|---|---|
| `home/` | A mirror of `$HOME`. Everything in it lands at the same path on your machine. |
| `paths.txt` | The list of files and folders that are tracked. Edit it to add or drop things. |
| `collect.sh` | Copies your live config into `home/` so you can commit it. |
| `install.sh` | Puts `home/` onto a machine that already has HyDE. Backs up first. |

## Install

You need CachyOS with HyDE already installed and working.

```
git clone https://github.com/UntitledBro1/hyde-dotfiles
cd hyde-dotfiles
./install.sh
```

The script lists what it will change and asks once. Everything it replaces is copied to `~/.config/hyde-dotfiles-backup/<time>/` first. It skips `monitors.conf` and `nvidia.conf` because those belong to the machine; add `--with-machine` if you want them too.

Other flags: `--dry-run` shows the plan and changes nothing, `--yes` skips the prompt.

Then run `hyde-shell reload && hyprctl reload`, or log out and back in.

### Installing with an AI agent

Paste this repo's link into your coding agent and ask it to install the dots. For the agent:

1. Confirm HyDE is installed: `command -v hyde-shell` should succeed. Stop if it doesn't.
2. Clone and run the installer without the prompt:
   ```
   git clone https://github.com/UntitledBro1/hyde-dotfiles ~/hyde-dotfiles
   ~/hyde-dotfiles/install.sh --yes
   ```
3. Tell the user where the backup folder is (the installer prints it).

Don't copy files into `~/.config` by hand or edit `monitors.conf`. The installer backs up everything it replaces; hand edits skip that.

## Themes

<!-- List the themes you use. HyDE can import one from its repo: -->
- *Theme name* by *author*: `hyde-shell theme import` then follow the prompt, or use the theme's own install instructions.

Themes and wallpapers belong to their creators.

## Make it yours

- **Keybindings and window rules:** `~/.config/hypr/keybindings.conf` and `windowrules.conf` (or your Lua modules under `~/.config/hypr/lua/` on the new layout).
- **HyDE options:** `~/.config/hyde/config.toml`.
- **Bar:** `~/.config/waybar/`, switch layouts with `hyde-shell waybar`.

## Keeping it up to date

After you change your setup, snapshot it and push:

```
./collect.sh
git add -A && git commit -m "update" && git push
```

`collect.sh` also scans for lines that look like API keys or passwords. Read what it prints before you push.

## Undo

Backups mirror your home folder, so restoring is one command:

```
cp -a ~/.config/hyde-dotfiles-backup/<time>/. ~/
hyde-shell reload && hyprctl reload
```

## Notes

- HyDE is moving from `.conf` files to a Lua-based Hyprland config. `paths.txt` lists both layouts and skips whichever you don't have.
- Built and used on *your hardware*, CachyOS, HyDE *version/commit*. Other setups are untested.
- Updating HyDE can overwrite some files it manages. Re-run `./install.sh` afterwards if something reverts.

## Credits

- [HyDE](https://github.com/HyDE-Project/HyDE) by the HyDE Project, MIT licensed.
- Install flow modelled on [denonmaryland/omarchy-dotfiles](https://github.com/denonmaryland/omarchy-dotfiles).
- Themes and wallpapers belong to their creators.

## License

MIT. Add a `LICENSE` file (GitHub offers one when you create the repo).
