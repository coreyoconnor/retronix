{
  self,
  cmd-on-event,
}: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.retronix;
  cmd-on-event-pkg = cmd-on-event.packages.${system}.default;
  restart-display-manager = "/run/current-system/sw/bin/systemctl restart display-manager.service";
in
  with lib; {
    config = mkIf cfg.enable {
      security.sudo.extraRules = [
        {
          users = [cfg.user];
          commands = [
            {
              command = restart-display-manager;
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/reboot";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];

      systemd.services.pad-control = {
        enable = true;
        wantedBy = ["multi-user.target"];

        unitConfig = {
          RequiresMountsFor = "/dev/input";
        };

        path = [
          "/run/current-system/sw/bin"
          "/run/wrappers/bin"
        ];

        serviceConfig = {
          User = cfg.user;
          Restart = "always";
          RestartSec = "5";
        };

        script = ''
          controllers=$(find /dev/input/by-id -iname '*Sony_*Controller*event-joystick' -o -iname 'stadia-controller*' || exit 0)
          if [ -n "$controllers" ]; then
             for controller in $controllers; do
               echo listening to $controller
               ${cmd-on-event-pkg}/bin/cmd-on-event from $controller \
                   key BTN_TRIGGER_HAPPY after 2000 exec /run/wrappers/bin/sudo ${restart-display-manager} \; \
                   key BTN_TRIGGER_HAPPY after 40000 exec /run/wrappers/bin/sudo /run/current-system/sw/bin/reboot &
             done
             wait -n
          else
            echo waiting for controllers...
            sleep 5
          fi
        '';
      };
    };
  }
