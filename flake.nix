{
  description = "Cloudfleet Nix packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      # Overlay: add `cloudfleet` to pkgs so configs can use `pkgs.cloudfleet`.
      overlays.default = final: _prev: {
        cloudfleet = final.callPackage ./pkgs/cloudfleet/default.nix { };
      };

      packages = forAllSystems (pkgs: rec {
        cloudfleet = pkgs.callPackage ./pkgs/cloudfleet/default.nix { };
        default = cloudfleet;
      });

      # `nix run github:cloudfleetai/nur` for a zero-install try.
      apps = forAllSystems (pkgs: rec {
        cloudfleet = {
          type = "app";
          program = "${self.packages.${pkgs.system}.cloudfleet}/bin/cloudfleet";
        };
        default = cloudfleet;
      });
    };
}
