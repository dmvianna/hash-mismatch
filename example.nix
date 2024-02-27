{ pkgs, ... }:

{
  services = {

    prometheus = {
      enable = true;
      exporters = {
        node = {
          port = 3021;
          enabledCollectors = [ "systemd" ];
          enable = true;
        };
      };
    };

    resolved.enable = true;
  };

  system.stateVersion = "23.11";
}
