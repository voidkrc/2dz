{
  description = "z_engine";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ zig zls glfw libGL ];
        shellHook = ''
          unset NIX_CFLAGS_COMPILE
          exec zsh
        '';
      };
    };
}
