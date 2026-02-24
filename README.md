# Universal NixOS (Gaming Ready)

This flake merges reusable patterns from:
- `kaku-niri`
- `nixos-master`
- `shin-hjem`
- `glf-os-testing` (gaming only)

Only these GLF parts are reused:
- gaming optimizations
- controller setup
- gaming programs

No personal hostnames, users, secrets, disk UUIDs, or ISO-only settings are included.

## Desktop Stack

The universal profile is now set to:
- Window manager: `Niri`
- Shell: `Nu` (Nushell)
- Terminal: `Ghostty`
- Panel: `Quickshell` (DMS-style setup)
- Notify daemon: `Dunst`
- Launcher: `AnyRun`
- File manager: `Yazi`
- Basic IDE: `Helix`
- GTK theme: `Colloid-Dark`
- Lockscreen: `Hyprlock`

## Included Host Presets

- `.#razer-blade-pro-2014` (Intel + NVIDIA laptop profile)
- `.#amd-laptop` (full AMD laptop profile)
- `.#desktop-pc` (desktop profile, default NVIDIA)

## 1) Edit User Defaults

Update `profiles/user.nix`:
- `universal.user.name`
- `universal.user.fullName`
- `universal.user.hashedPassword` (recommended)
- `universal.system.timeZone`
- `universal.system.locale`

If `hashedPassword = null`, the first boot password is `changeme`.

## 2) (Optional) Desktop GPU Vendor

For desktop profile, set `universal.desktop.gpuVendor` in `hosts/desktop-pc.nix`:
- `"nvidia"`
- `"amd"`
- `"intel"`

## 3) Add Hardware File (per machine)

Generate and copy hardware config for the host you install:

```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix ./hardware/amd-laptop.nix
```

Use matching file names:
- `hardware/razer-blade-pro-2014.nix`
- `hardware/amd-laptop.nix`
- `hardware/desktop-pc.nix`

The flake auto-imports `hardware/<host>.nix` when present.

## 4) Install

From installer shell:

```bash
sudo nixos-install --flake .#amd-laptop
```

After install:

```bash
sudo nixos-rebuild switch --flake .#amd-laptop
```

Replace `amd-laptop` with:
- `razer-blade-pro-2014`
- `desktop-pc`

## 5) What Was Kept Universal

- shared base modules (`modules/base`)
- hardware presets (`modules/hardware`)
- GLF gaming stack (`modules/gaming/glf`)

## 6) What Was Removed

- per-user home-manager personalization
- private secrets and age keys
- machine-specific storage UUIDs and host overrides
- non-gaming GLF ISO customizations

