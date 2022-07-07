{ config, pkgs, lib, ... }:

with lib;
let cfg = config.retronix;
    cmd-on-event-src = pkgs.fetchgit {
      url = "https://gitlab.com/coreyoconnor/cmd-on-event.git";
      rev = "6143143a85f0cde3093710937b7ecb019fbf43ec";
      sha256 = "0ci1mmmlv2sw49kd30ck3y0fgcd9931vrxyr86zw3dm0ma6f9kjk";
    };
    cmd-on-event = (import cmd-on-event-src) {
      inherit pkgs;
      src = cmd-on-event-src;
      outputHash = "063s7xnc6lh47b95z8wgdx0srhfd7hdl9sqlgzx9z519x4d07rnk";
    };
    restart-display-manager = "${pkgs.systemd}/bin/systemctl restart display-manager.service";
in {
  imports =
  [
    ./modules/retroarch.nix
  ];

  options =
  {
    retronix = {
      enable = mkOption
      {
        default = false;
        example = true;
        type = with types; bool;
      };

      user = mkOption
      {
        default = "retronix";
        example = "retronix";
        type = with types; str;
      };

      nick = mkOption {
        default = "retronix";
        example = "gamer256";
        type = with types; str;
      };
    };
  };

  config = mkIf config.retronix.enable {
    environment.systemPackages = with pkgs; [
      cmd-on-event.cmd-on-event
      wine
      winetricks
    ];

    security.sudo.extraRules = [
      {
        users = [ cfg.user ];
        commands = [
          {
            command = restart-display-manager;
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    systemd.services.pad-control = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

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
        controllers=$(find /dev/input/by-id -iname '*Sony_*Controller*event-joystick')
        if [ -n "$controllers" ]; then
           for controller in $controllers; do
             echo listening to $controller
             ${cmd-on-event.cmd-on-event}/bin/cmd-on-event from $controller \
                 key BTN_MODE after 5000 exec sudo ${restart-display-manager} &
           done
           wait -n
        else
          echo waiting for controllers...
          sleep 5
        fi
      '';
    };

    services.xserver.desktopManager.session = [{
      name = "retronix";
      start = ''
        mkdir -p $HOME/.config/retroarch/cores
        cp --remove-destination ${pkgs.retroarchFull}/lib/*.so $HOME/.config/retroarch/cores/
        # pre-compiled cores will be copied read-only. This will block the auto updater,
        # This is intentional: The precompiled ones should be those that *must*
        # be compiled via nix.
        ${pkgs.retroarchFull}/bin/retroarch --verbose --nick ${cfg.nick} &
        waitPID=$!
      '';
    }];
  };
}
