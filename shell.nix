{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  packages = [
    python3
    stow

    # Language servers for...
    lua-language-server # ...Lua.
    pyright # ...Python.
    nixd # ...Nix.

    # Formatters for...
    treefmt # ...everything under the sun.
    stylua # ...Lua.
    nixpkgs-fmt # ...Nix.
    black # ...Python.
    nufmt # ... Nushell.
  ];
}
