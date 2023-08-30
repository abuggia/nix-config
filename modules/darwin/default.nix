{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;

  environment = {
    shells = [ pkgs.bashInteractive pkgs.zsh ];
    loginShell = pkgs.zsh;
    systemPath = [ "/opt/homebrew/bin" ];
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.stateVersion = 4;

  fonts.fontDir.enable = true;
  fonts.fonts = [ (pkgs.nerdfonts.override {
    fonts = [ "Meslo" ];
  }) ];

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      Kindle = 405399194;
    };
    casks = [ ];
    taps = [ ];
    brews = [ ];
  };
}
