{
  inputs,
  pkgs,
  adam-neovim,
  ...
}: {

  home.stateVersion = "23.05";
  home.homeDirectory = "/Users/adam";

  home.packages = with pkgs; [
    adam-neovim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    tree
    jq
    ripgrep
    fd
    watch
    nurl
    treemd
  ];

  programs.bat = {
    enable = true;
    # config.theme = "TwoDark";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = pkgs.lib.readFile ./.zshrc;
    autosuggestion.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "Adam Buggia";
        email = "abuggia@gmail.com";
      };

      extraConfig = {
        color.ui = true;
        github.user = "abuggia";
        push.default = "tracking";
        init.defaultBranch = "main";
      };
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 10000;
    extraConfig = pkgs.lib.readFile ./tmux.conf;
  };

  programs.alacritty.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}
