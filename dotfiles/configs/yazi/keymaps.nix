{ ... }: {
  manager.prepend_keymap = [
    {
      on = "!";
      run = ''
        shell "env YAZI_PROMPT=1 fish" --block
      '';
      desc = "Open shell here";
    }
  ];
}
