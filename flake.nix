{
  description = "A very basic flake";
  inputs = {
      # local directories (for absolute paths you can omit 'path:')
      a-flake.url = "path:./a-flake";
      b-flake.url = "path:./b-flake";
  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

  };
}
