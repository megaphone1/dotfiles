{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.hyprland =
    {
      pkgs,
      config,
      ...
    }:
    {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      hardware.graphics = {
        package = pkgs.mesa;
      };

      services.seatd = {
        enable = true;
      };

      users.users.${config.user.name} = {
        extraGroups = [
          "video"
          "seat"
        ];
      };

      security.polkit.enable = true;

      environment.sessionVariables = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
        cliphist
      ];

      services.getty.autologinUser = "${config.user.name}";
      environment.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          exec start-hyprland
        fi
      '';
    };

  flake.homeModules.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      configType = "lua";
      extraConfig = ''
        hl.config({
            misc = {
                force_default_wallpaper = 0,
        	      disable_hyprland_logo = true,
        	      disable_splash_rendering = true,
            },
        })

        hl.monitor({
        	output   = "",
        	mode     = "preferred",
        	position = "auto",
        	scale    = "auto",
        })

        local editor = "emacs"
        local browser = "firefox"
        local terminal = "ghostty"
        local terminalAlt = "alacritty"
        local fileManager = "ghostty -e yazi"

        local launcherMenu = "noctalia msg panel-toggle launcher"
        local launcherEmoji = "noctalia msg panel-toggle launcher /emo"

        local wallpaperPicker = "noctalia msg panel-toggle wallpaper"
        local wallpaperRandom = "noctalia msg wallpaper-random"

        local screenshot = "noctalia msg screenshot-fullscreen"
        local screenshotRegion = "noctalia msg screenshot-region"

        hl.on("hyprland.start", function ()
            hl.exec_cmd("noctalia")
            hl.exec_cmd("wl-clip-persist --clipboard regular")
        end)

        hl.env("XCURSOR_SIZE", "24")
        hl.env("HYPRCURSOR_SIZE", "24")

        hl.config({
            general = {
                gaps_in = 5,
        	      gaps_out = 10,
            },

            decoration = {
                rounding = 20,
        	      rounding_power = 2,

                shadow = {
        	          enabled = true,
        	          range = 4,
        	          render_power = 3,
        	          color = 0xee1a1a1a,
        	      },

        	      blur = {
        	          enabled = true,
        	          size = 3,
        	          passes = 2,
        	          vibrancy = 0.1696,
        	      },
            },
        })

        local noctaliaLayerRule = hl.layer_rule({
            name = "noctalia",
            match = { namespace = "noctalia-background-.*$" },
            ignore_alpha = 0.5,
            blur = true,
            blur_popups = true,
        })

        noctaliaLayerRule:set_enabled(true)

        hl.config({
            input = {
                kb_layout = "us",
        	      kb_variant = "",
        	      kb_model = "",
        	      kb_options = "",
        	      kb_rules = "",

        	      follow_mouse = 1,

        	      sensitivity = 0,

        	      touchpad = {
        	          natural_scroll = false,
        	      },
            },
        })

        hl.gesture({
            fingers = 3,
            direction = "horizontal",
            action = "workspace",
        })

        hl.device({
            name = "epic-mouse-v1",
            sensitivity = -0.5,
        })

        local mainMod = "SUPER"

        hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
        hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminalAlt))
        hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(editor))
        hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
        hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))

        hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(launcherMenu))
        hl.bind(mainMod .. " + J", hl.dsp.exec_cmd(launcherEmoji))

        hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(wallpaperRandom))
        hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(wallpaperPicker))

        hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(screenshot))
        hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshotRegion))

        hl.bind(mainMod .. " + Q", hl.dsp.window.close())
        hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
        hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

        hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
        hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
        hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
        hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

        for i = 1, 10 do
            local key = i % 10
            hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
            hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
        hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
        hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

        hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

        local supressMaximizeRule = hl.window_rule({
            name = "supress-maximize-events",
            match = { class = ".*" },
            suppress_event = "maximize",
        })

        supressMaximizeRule:set_enabled(true)

        hl.window_rule({
            name = "fix-xwayland-drags",
            match = {
                class = "^$",
        	      title = "^$",
        	      xwayland = true,
        	      float = true,
        	      fullscreen = false,
        	      pin = false,
            },

            no_focus = true,
        })

        hl.window_rule({
            name = "move-hyprland-run",
            match = { class = "hyprland-run" },
            move = "20 monitor_h-120",
            float = true,
        })
      '';
    };
  };
}
