{ ... }: {
  programs.nh.enable = true;
  programs.nh = {
    clean.
      enable = true;
    clean.extraArgs = "--keep 2 --keep-since 3d";
  };
}
