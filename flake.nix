{
  description = "Universal NixOS gaming-ready flake for laptops and desktops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      lib = nixpkgs.lib;

      mkHost = hostName: hostModule: system:
        let
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          hardwareModule = ./. + "/hardware/${hostName}.nix";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit pkgs-unstable;
          };
          modules =
            [
              ./profiles/user.nix
              hostModule
            ]
            ++ lib.optional (builtins.pathExists hardwareModule) hardwareModule;
        };
    in
    {
      nixosConfigurations = {
        razer-blade-pro-2014 = mkHost "razer-blade-pro-2014" ./hosts/razer-blade-pro-2014.nix "x86_64-linux";
        amd-laptop = mkHost "amd-laptop" ./hosts/amd-laptop.nix "x86_64-linux";
        desktop-pc = mkHost "desktop-pc" ./hosts/desktop-pc.nix "x86_64-linux";
      };
    };
}

