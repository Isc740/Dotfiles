{
  description = "My NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nixvim.url = "github:nix-community/nixvim";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # xremap-flake.url = "github:xremap/nix-flake";
    # xremap-flake.inputs.nixpkgs.follows = "nixpkgs";

    nvim-pkg.url = "path:./modules/kickstart-nix.nvim";
    nvim-pkg.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, home-manager, xremap-flake, nvim-pkg, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        xremap-flake.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.isaac = import ./home-manager/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };

         #  services.xremap.withX11 = true;
         #  services.xremap.config.modmap = [{
         #    name = "Global";
         #    remap = { "CapsLock" = "Shift_L"; };
         #  }];
         #  nixpkgs.overlays = [
         #    nvim-pkg.overlays.default
         # ];
        }
      ];
    };
  };
}
