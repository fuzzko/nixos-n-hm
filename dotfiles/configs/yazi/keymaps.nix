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
      on = "l";
      run = ''
        plugin smart-enter
      '';
      desc = "Enter the child directory, or open the file";
    }
    {
      on = "C";
      run = "plugin ouch --args=zip";
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
      desc = "Diff the selected with the hovered file";
      on = "<C-d>";
      run = "plugin diff";
    }
  ];
}
