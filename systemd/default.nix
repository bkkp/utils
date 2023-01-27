nixpkgs:
let
    pkgs = import nixpkgs {system = "x86_64-linux";};

in
# If we add more similar scripts, put in same bin folder
pkgs.writeShellApplication {
    name = "exporestart"; text = builtins.readFile ./exporestart.sh;
}