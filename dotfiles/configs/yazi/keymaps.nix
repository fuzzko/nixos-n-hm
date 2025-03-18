{ ... }:
{
  manager.prepend_keymap = [
    {
      on = "!";
      run = ''
        shell "env YAZI_PROMPT=1 fish" --block
      '';
      desc = "Open shell here";
    }
    {
      on = [ "l" ];
      run = "plugin bypass smart_enter";
      desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory";
    }
    {
      on = "C";
      run = "plugin ouch zip";
      desc = "Compress with ouch";
    }
    {
      on = "<C-e>";
      run = "seek 5";
    }
    {
      on = "<C-y>";
      run = "seek -5";
    }
    {
      on = "<C-d>";
      run = "plugin diff";
      desc = "Diff the selected with the hovered file";
    }
    {
      on = [
        "c"
        "m"
      ];
      run = "plugin chmod";
      desc = "Chmod on selected files";
    }
    {
      on = [
        "f"
        "j"
      ];
      run = "plugin first-non-directory";
      desc = "Jumps to the first file";
    }
  ];
}
