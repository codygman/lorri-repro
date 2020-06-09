{
  nixpkgs = builtins.fetchGit {
    name = "nixos-unstable-2020-04-06-ish";
    url = "https://github.com/NixOS/nixpkgs.git";
    ref = "nixpkgs-unstable";
    rev = "8686922e68dfce2786722acad9593ad392297188";
  };
}
