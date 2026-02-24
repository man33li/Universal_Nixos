# Hardware Modules

Create one hardware file per host with the generated hardware configuration:

- `hardware/razer-blade-pro-2014.nix`
- `hardware/amd-laptop.nix`
- `hardware/desktop-pc.nix`

Example from installer environment:

```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix /path/to/universal-nixos/hardware/amd-laptop.nix
```

The flake auto-imports `hardware/<host>.nix` when the file exists.
