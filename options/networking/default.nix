{ ... }: {
  networking.networkmanager.enable = true;
  networking.networkmanager = {
    wifi.backend = "iwd";
  };

  networking.networkmanager.settings = {
    logging = {
      level = "TRACE";
      domains = "ALL";
    };
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  services.resolved = {
    enable = true;
    fallbackDns = [
      "127.0.0.1"
      "::1"
    ];
    dnsovertls = "true";
  };
}
