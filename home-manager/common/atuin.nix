{ pkgs, ... }:
{
  programs.atuin.enable = true;

  programs.atuin.enableZshIntegration = true;
  # programs.atuin.enableBashIntegration = true;

  programs.atuin.settings = {
    # auto_sync = true;
    enter_accept = true;
    # sync_frequency = "5m";
    sync_address = "https://api.atuin.sh";
    # search_mode = "prefix";
    history_format = "{host}: {time}\t{command}\t{duration}";
    sync.records = true;
  };
}
