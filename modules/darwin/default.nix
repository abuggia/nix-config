{ pkgs, ... }: {

  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.stateVersion = 4;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    # defaults.NSGlobalDomain.AppleShowAllFiles = true;
  };

  environment = {
    shells = [ pkgs.bashInteractive pkgs.zsh ];
    systemPath = [ "/opt/homebrew/bin" ];
    systemPackages = with pkgs; [
      comma
    ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.meslo-lg
  ];

  homebrew = {
    # enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      Kindle = 302584613;
    };
    casks = [
      {
        name = "docker";
        greedy = true;
      }
      "raycast"
      "obsidian"
    ];
    taps = [ ];
    brews = [ ];
  };
}
