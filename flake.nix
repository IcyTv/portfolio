{
  description = "Neovim-powered graphical editor built with Iced";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nvim = {
      url = "github:IcyTv/nvim.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nvim,
    ...
  }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "cmp-spell"
              "copilot-language-server"
            ];
        };

        neovim = nvim.lib.makeNeovimWithLanguages {
          inherit pkgs system;
          languages = {
            nix.enable = true;
            tailwind.enable = true;
            astro.enable = true;
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            neovim
            bun
          ];
        };
      }
    );
}
