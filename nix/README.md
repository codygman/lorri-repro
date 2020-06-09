# ghcide setup (tested on fresh Ubuntu 20.04 install)

This uses [codium](https://vscodium.com/) mainly because it's exactly like vscode but conveniently has a binary named `codium` rather than `code` meaning it won't mess with your current `code` binary.

You can install it with:

``` sh
cd ~/path/to/smurf/nix/ghcide-setup
sh nix_install.sh # note sudo might be required to install curl if you don't have it already
```

Add the appropriate shell hook:

``` sh
# ~/.zshrc
eval "$(direnv hook zsh)"
# ~/.bashrc
eval "$(direnv hook bash)"
# ~/.config/fish/config.fish
eval (direnv hook fish)
```

Now you can open a file like:

``` sh
codium ~/path/to/smurf/library/CsodApi.hs
```

Make sure in the bottom left you have selected `shell.nix` from `nix-env-selector`.

Then everything should work.

