# compose-flakes

A Nix flake is a directory that contains a flake.nix file. That file must contain an attribute set with one required attribute – outputs – and optionally description and inputs.

need to output two devShells and then compose them into one.
https://github.com/aleeusgr/compose-flakes/issues/1

a-flake -> haskell, devshell should respond to ghc --version
b-flake -> python, python --version
. -> both python and haskell

## Docs
https://nixos.org/guides/nix-pills/index.html

https://ianthehenry.com/posts/how-to-learn-nix/
https://ianthehenry.com/posts/how-to-learn-nix/nix-develop/
https://ianthehenry.com/posts/how-to-learn-nix/the-standard-environment/

https://serokell.io/blog/practical-nix-flakes#getting-a-feel-for-flakes

https://yuanwang.ca/posts/getting-started-with-flakes.html
https://xeiaso.net/blog/nix-flakes-1-2022-02-21

https://nixos.wiki/wiki/Flakes
https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html

I don't think this is needed, but overlays are often mentioned

https://nixos.wiki/wiki/Overlays
https://nixos.org/manual/nixpkgs/stable/#sec-overlays-definition
