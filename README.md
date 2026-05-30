# Cloudfleet Nix packages

Nix packages for [Cloudfleet](https://cloudfleet.ai) tools

The Cloudfleet CLI is distributed as a closed-source binary, so the package is marked `unfree`. You must allow unfree packages to install it.

## Install

Because the CLI is unfree, you must allow unfree packages. In a config file
that's a single setting (`nixpkgs.config.allowUnfree = true;`, which most people
running any unfree software already have); for one-off imperative commands it's
the `NIXPKGS_ALLOW_UNFREE=1` env var plus `--impure`.

### As an overlay (recommended)

Add the overlay once and use `pkgs.cloudfleet` like any native package:

```nix
{
  inputs.cloudfleet.url = "github:cloudfleetai/nur";

  outputs = { nixpkgs, cloudfleet, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.overlays = [ cloudfleet.overlays.default ];
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [ pkgs.cloudfleet ];
        }
      ];
    };
  };
}
```

### Direct package reference

Without the overlay, reference the package output directly:

```nix
# NixOS
environment.systemPackages = [ cloudfleet.packages.x86_64-linux.cloudfleet ];

# home-manager
home.packages = [ inputs.cloudfleet.packages.${pkgs.system}.cloudfleet ];
```

### Try it without installing

```bash
NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:cloudfleetai/nur#cloudfleet -- --version
```

### Imperative install

```bash
NIXPKGS_ALLOW_UNFREE=1 nix profile install --impure github:cloudfleetai/nur#cloudfleet
```

## Available packages

- `cloudfleet` — the Cloudfleet CLI (includes the `docker-credential-cloudfleet`
  helper and shell completions).
