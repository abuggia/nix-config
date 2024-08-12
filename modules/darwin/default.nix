{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.stateVersion = 4;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults.NSGlobalDomain.AppleShowAllFiles = true;
  };

  environment = {
    shells = [ pkgs.bashInteractive pkgs.zsh ];
    loginShell = pkgs.zsh;
    systemPath = [ "/opt/homebrew/bin" ];
    systemPackages = with pkgs; [
      comma
    ];
  };

  #fonts.fontDir.enable = true;
  #fonts.fonts = [ (pkgs.nerdfonts.override {
  #  fonts = [ "Meslo" ];
  #}) ];

  homebrew = {
    enable = true;
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
