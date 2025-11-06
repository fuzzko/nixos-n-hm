{ config, ... }:
let
  inherit (config.lib) komo;
in
{
  programs.starship.enable = true;

  programs.starship.settings = {
    add_newline = false;

    format = komo.trimEveryLine ''
      [╭────╴](228) $hostname [╶$fill╴](228)
      [├╴](228)$directory(
      [├╴](228)$git_branch( $git_state)( $git_commit)( $git_status)( $git_metrics))(
      [├╴](228)$shlvl)(
      [├╴](228)$jobs)
      [╰─╴](228)($nix_shell )$character
    '';

    character = {
      format = "$symbol ";
      vimcmd_replace_one_symbol = "[H](bold purple)";
      vimcmd_replace_symbol = "[H](bold purple)";
      vimcmd_symbol = "[H](bold green)";
      vimcmd_visual_symbol = "[H](bold yellow)";
    };

    directory = {
      format = "📁 [$path]($style) [$read_only]($read_only_style)";
      style = "yellow bold";
      truncate_to_repo = true;
      truncation_length = 8;
      truncation_symbol = "…/";
    };

    fill = {
      style = "228";
      symbol = "─";
    };

    git_branch = {
      format = "[$symbol $branch(:$remote_branch)]($style)";
      style = "208 bold";
      symbol = "";
    };

    git_commit = {
      format = "[\\($hash$tag\\)]($style)";
      only_detached = true;
      style = "208 bold";
      tag_symbol = " 󰓹 ";
    };

    git_metrics = {
      disabled = false;
    };

    git_status = {
      ahead = "🡱";
      behind = "🡳";
      diverged = "⮁";
      format = "[($all_status$ahead_behind)]($style)";
      style = "119 bold";
    };

    hostname = {
      format = "[@$hostname]($style)";
      ssh_only = false;
      style = "221 bold";
      trim_at = "";
    };

    jobs = {
      format = "[$symbol [$number](bold blue) jobs]($style)";
      number_threshold = 1;
      style = "bold 68";
      symbol = "⚙️";
    };

    nix_shell = {
      format = "[\\($symbol\\)]($style)";
      heuristic = false;
      style = "75 bold";
      symbol = "❄️";
    };

    shlvl = {
      disabled = false;
      format = "[$symbol $shlvl]($style)";
      style = "255 bold";
      symbol = "[lv](white bold)";
    };
  };
}
