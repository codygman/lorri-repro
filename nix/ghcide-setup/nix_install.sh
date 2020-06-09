if ! [ -x "$(command -v curl)" ]; then
  echo "curl not installed, installing"
  sudo apt install -y curl
fi

. $HOME/.nix-profile/etc/profile.d/nix.sh
if ! [ -x "$(command -v nix-shell)" ]; then
  echo "nix not installed, installing"
  curl -L https://nixos.org/nix/install | sh
fi

. $HOME/.nix-profile/etc/profile.d/nix.sh

sed -i 's/someuser/$USER/g' home.nix
cp -bv home.nix ~/.config/nixpkgs/home.nix

if ! [ -x "$(command -v home-manager)" ]; then
  echo "home-manager not installed, installing"
  nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
fi

home-manager switch
codium --install-extension digitalassetholdingsllc.ghcide
codium --install-extension arrterian.nix-env-selector
codium --install-extension bbenoist.Nix
