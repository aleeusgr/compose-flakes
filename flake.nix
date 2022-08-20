{
  description = "A very basic flake";
  inputs = {
      # local directories (for absolute paths you can omit 'path:')
      a-flake.url = "path:./a-flake";
      b-flake.url = "path:./b-flake";
    };
  outputs = { self, nixpkgs, a-flake, b-flake }: {
  
    stdenv.mkDerivation {
      name = "libfoo-1.2.3";
      ...
      buildInputs = [a-flake b-flake];
  }
  };
}
