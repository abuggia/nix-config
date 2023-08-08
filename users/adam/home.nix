{
  inputs,
  pkgs,
  adam-neovim,
  ...
}: {

  home.stateVersion = "23.05";
  home.homeDirectory = "/Users/adam";

  home.packages = [
    adam-neovim.packages.${pkgs.system}.nvim
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
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls --color=auto -Fla";
      rebuild="darwin-rebuild switch --flake ~/Dropbox/projects/macos-config/flake.nix";
      config="nvim ~/Dropbox/projects/macos-config";
      brain="nvim ~/Dropbox/brain";
    };
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # programs.alacritty = { enable = true; };

  programs.git.enable = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 10000;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      gruvbox
    ];
    extraConfig = ''
      new-session -s main
      bind-key -n C-a send-prefix
    '';
  };

}
