{
  description = "ZMK Config development shell";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.mkShell {
      packages = with pkgs; [ python313 keymap-drawer entr feh ];

      shellHook = ''
        echo
        printf "⌨️ \e[38;5;195mZMK Config\033[0m\n"
        echo
      '';
    };
  };
}

