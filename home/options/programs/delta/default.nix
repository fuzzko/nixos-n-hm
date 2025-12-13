{ config, ... }:
{
  programs.delta.enable = config.programs.git.enable;
  programs.delta.enableGitIntegration = config.programs.git.enable;
  programs.delta.options = {
    line-numbers = true;
  };
}
