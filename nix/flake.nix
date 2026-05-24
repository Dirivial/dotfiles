{
  description = "NixOS with Hyprland";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/common/configuration.nix
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alkade = {
                imports = [
                  ./modules/common/home.nix
                  ./hosts/laptop/home.nix
                ];
              };
              backupFileExtension = "backup";
            };
          }
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/common/configuration.nix
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alkade = {
                imports = [
                  ./modules/common/home.nix
                  ./hosts/desktop/home.nix
                ];
              };
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
  };
}
