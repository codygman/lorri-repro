nixpkgsSelf: nixpkgsSuper:

let
  inherit (nixpkgsSelf) pkgs;

  ghcVersion = "ghc883";

  hsPkgs = nixpkgsSuper.haskell.packages.${ghcVersion}.override {
    overrides = with pkgs.haskell.lib; hSelf: hSuper: {
      bson = disableLibraryProfiling (dontCheck (addBuildDepend (markUnbroken hSuper.bson) hSelf.network-bsd));
      mongoDB = disableLibraryProfiling (dontCheck (markUnbroken (hSelf.callHackage "mongoDB" "2.7.0.0" {})));
      HPDF = doJailbreak
        (disableLibraryProfiling (dontCheck
          (markUnbroken
            (
              hSuper.callCabal2nix "HPDF" (
                builtins.fetchGit {
                  url = "https://github.com/tfausak/HPDF";
                  ref = "ghc-eight-eight";
                  rev = "31e2b887cd32661b1ac936335635be5c00216bc8";
                }
              ) {}
            ))));
      convertible = doJailbreak
        (dontCheck
          (markUnbroken
            (
              hSuper.callCabal2nix "convertible" (
                builtins.fetchGit {
                  url = "https://github.com/tfausak/convertible";
                  ref = "monad-fail";
                  rev = "9e4849e143458aa3175e71bc2a8a29502272eb88";
                }
              ) {}
            )));
      orville = hSuper.callCabal2nix "orville" (
        pkgs.fetchFromGitHub {
          owner = "EdutainmentLive";
          repo = "orville";
          rev = "8a2432891e96a547777b67a67135e235a1dce80c";
          sha256 = "0i8z3zr4z55bzidlh3pz3r3h0hachk5ndfhznw3kqk4c5j6y27ry";
        }) {};
      # NOTE for some reason the actual binary doesn't seem to be on the path
      # source of issue likely https://github.com/NixOS/nixpkgs/pull/84985
      #  warning message confirms:
      #  Warning: The directory
      # /nix/store/lmgqm5gfkxg6gpilrcj2wsvcc0a2hmqp-ghcide-0.2.0/bin is not in the
      #   system search path.
      # NOTE: my current workaround is just to tell my editor the absolute path: /nix/store/lmgqm5gfkxg6gpilrcj2wsvcc0a2hmqp-ghcide-0.2.0/bin/ghcide
      # I think if I just upgrade nix though, it might be fixed... can't tell from the linked pull request above what's still broke
      ghcide = justStaticExecutables (dontCheck (disableLibraryProfiling (hSuper.callCabal2nix "ghcide" (
        pkgs.fetchFromGitHub {
          owner = "digital-asset";
          repo = "ghcide";
          rev = "4149ab539d736328e29957c7eee752e0413fdd40";
          sha256 = "1d5jpff480p9i2fypxp9cmjjbivi1fy1lw3xhimq7iizwywdnsxv";
        }) {})));
      # tests that require files write to homeless-shelter and don't have permission
      # TODO see https://discourse.nixos.org/t/trying-to-package-doom-emacs/3646/3
      hie-bios = disableLibraryProfiling (dontCheck (markUnbroken (hSuper.callCabal2nix "hie-bios" (
        pkgs.fetchFromGitHub {
          owner = "mpickering";
          repo = "hie-bios";
          rev = "0044432e6eebce151a0cb0003ee5e40a8a17cd25";
          sha256 = "1rpxaa2brd5b900ngyc2g47dzblqi617s03581mbly034gnjybc0";
        }) {})));
      haskell-lsp = disableLibraryProfiling (dontCheck (
        hSelf.callHackageDirect {
          pkg = "haskell-lsp";
          ver = "0.22.0.0";
          sha256 = "1q3w46qcvzraxgmw75s7bl0qvb2fvff242r5vfx95sqska566b4m";
        } {}
      ));
      lsp-test = disableLibraryProfiling (dontCheck (
        hSelf.callHackageDirect {
          pkg = "lsp-test";
          ver = "0.11.0.1";
          sha256 = "085mx5kfxls6y8kyrx0v1xiwrrcazx10ab5j4l5whs4ll44rl1bh";
        } {}
      ));
      ghc-check = disableLibraryProfiling (dontCheck (
        hSelf.callHackageDirect {
          pkg = "ghc-check";
          ver = "0.3.0.1";
          sha256 = "1dj909m09m24315x51vxvcl28936ahsw4mavbc53danif3wy09ns";
        } {}
      ));
      haskell-lsp-types = disableLibraryProfiling (dontCheck (
        hSelf.callHackageDirect {
          pkg = "haskell-lsp-types";
          ver = "0.22.0.0";
          sha256 = "1apjclphi2v6ggrdnbc0azxbb1gkfj3x1vkwpc8qd6lsrbyaf0n8";
        } {}));
    };
  };

in
{
  haskell = nixpkgsSuper.haskell // {
    inherit ghcVersion;

    packages = nixpkgsSuper.haskell.packages // {
      "${ghcVersion}" = hsPkgs;
    };
  };
}
