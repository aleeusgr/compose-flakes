{
  description = "A very basic flake";
  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs"; 
      # flake-utils.url = "github:numtide/flake-utils";
      # local directories (for absolute paths you can omit 'path:')
      a-flake.url = "/home/alex/workshop/nix/compose-flakes/a-flake";
      b-flake.url = "/home/alex/workshop/nix/compose-flakes/b-flake";
    };
  outputs = { self, nixpkgs, a-flake, b-flake } @ inputs: 
  {
    devShell.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.mkShell 
    {
    #      buildInputs = with nixpkgs; [];
    #      inputsFrom = [self.devShell.a-flake self.devShell.b-flake];
    };
  };
}
