{
  pkgs,
  lib,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.vim ];

  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nix;
  nix.enable = false;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  stylix = {
    enable = true;
    image = ./wallpapers/collapse-night.png;
    polarity = "dark";
    opacity = {
      desktop = 0.9;
      popups = 0.9;
      applications = 0.9;
    };
  };
  nixpkgs.config.allowUnfree = true;
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  users.users."samuel.dasilva" = {
    name = "samuel.dasilva";
    home = /Users/samuel.dasilva;
  };
}
