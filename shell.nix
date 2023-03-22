let
  # See https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs for more information on pinning
  nixpkgs = builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-unstable-2020-11-07";
    # Commit hash for nixos-unstable as of 2019-02-26
    url = https://github.com/NixOS/nixpkgs/archive/c54c614000644ecf9b8f8e9c873cfa91d1c05bf1.tar.gz;
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "19xmsj1dhq25arhsfx0sl3r1y0zgpzfwhybc5dsxr1szh71wz3xs";
  };
in
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  packages = [
    python3
    stow

    # Language servers for...
    lua-language-server # ...Lua.
    pyright # ...Python.
    rnix-lsp # ...Nix.

    # Formatters for...
    treefmt # ...everything under the sun.
    stylua # ...Lua.
    nixpkgs-fmt # ...Nix.
    black # ...Python.
  ];
}
