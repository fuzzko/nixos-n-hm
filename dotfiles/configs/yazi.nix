{ lib, ... }:
{
  plugin = {
    prepend_previewers = lib.flatten [
      (builtins.map
        (x: {
          mime = "application/${x}";
          run = "ouch";
        })
        [
          "*zip"
          "x-tar"
          "x-bzip2"
          "x-7z-compressed"
          "x-rar"
          "x-xz"
        ]
      )
    ];
  };
}
