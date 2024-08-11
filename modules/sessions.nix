{self}: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.retronix;
  retronix-steam = pkgs.writeShellScriptBin "retronix-steam" ''
    exec gamescope --steam --rt -- steam -tenfoot -pipewire-dmabuf
  '';

  retronix-steam-session =
    (pkgs.writeTextDir "share/wayland-sessions/retronix-steam.desktop" ''
      [Desktop Entry]
      Name=Steam with RetroArch
      Comment=A digital distribution platform
      Exec=${retronix-steam}/bin/retronix-steam
      Type=Application
    '')
    .overrideAttrs (_: {passthru.providedSessions = ["retronix-steam"];});

  retronix = pkgs.writeShellScriptBin "retronix" ''
    mkdir -p $HOME/.config/retroarch/cores
    cp --remove-destination ${pkgs.retroarchFull}/lib/*.so $HOME/.config/retroarch/cores/
    # pre-compiled cores will be copied read-only. This will block the auto updater,
    # This is intentional: The precompiled ones should be those that *must*
    # be compiled via nix.
    exec ${pkgs.retroarchFull}/bin/retroarch --verbose
  '';

  retronix-gamescope = pkgs.writeShellScriptBin "retronix-steam" ''
    exec gamescope --rt -- ${retronix}/bin/retronix
  '';

  retronix-session =
    (pkgs.writeTextDir "share/wayland-sessions/retronix.desktop" ''
      [Desktop Entry]
      Name=RetroArch
      Comment=RetroArch
      Exec=${retronix-gamescope}/bin/retronix-gamescope
      Type=Application
    '')
    .overrideAttrs (_: {passthru.providedSessions = ["retronix"];});
in
  with lib; {
    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        retronix
        retronix-gamescope
        retronix-steam
      ];

      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
      };

      services = {
        displayManager = {
          defaultSession =
            if cfg.steamLauncher
            then "retronix-steam"
            else "retronix";

          autoLogin = {
            enable = true;
            user = cfg.user;
          };

          sddm = {
            enable = true;
            wayland.enable = true;
          };

          sessionPackages = [
            retronix-session
            retronix-steam-session
          ];
        };
      };
    };
  }
