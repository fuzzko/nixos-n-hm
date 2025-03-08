{ ... }: {
  manager.prepend_keymap = [
    {
      on = "!";
      run = ''
        shell "fish" --block
      '';
      desc = "Open shell here";
    }
  ];
}
