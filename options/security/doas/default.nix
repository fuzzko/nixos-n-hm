{...}: {
  security.sudo.enable = lib.mkForce false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "komo" ];
        persist = true;
      }
    ];
  };
}
