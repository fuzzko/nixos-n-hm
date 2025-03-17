{ ... }: {
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
  ];
}
