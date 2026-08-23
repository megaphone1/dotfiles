{
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

  flake.homeModules.hyprland = { lib, pkgs, ... }: {
    home.sessionVariables = {
        XCURSOR_SIZE = 24;
        HYPRCURSOR_SIZE = 24;
    };
    
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      configType = "lua";
      settings = {
        config = {
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          input = {
            kb_layout = "us";
        	  kb_variant = "";
        	  kb_model = "";
        	  kb_options = "";
        	  kb_rules = "";
        	  follow_mouse = 1;
        	  sensitivity = 0;

        	  touchpad = {
        	    natural_scroll = false;
        	  };
          };

          general = {
            gaps_in = 5;
        	  gaps_out = 10;
          };

          decoration = {
            rounding = 20;
        	  rounding_power = 2;

            shadow = {
        	    enabled = true;
        	    range = 4;
        	    render_power = 3;
        	  };

        	  blur = {
        	      enabled = true;
        	      size = 3;
        	      passes = 2;
        	      vibrancy = 0.1696;
        	  };
          };
        };

        monitor = {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        };

        layer_rule = {
          name = "noctalia";
          match = { namespace = "noctalia-background-.*$"; };
          ignore_alpha = 0.5;
          blur = true;
          blur_popups = true;
        };

        window_rule = [
          {
            name = "supress-maximize-events";
            suppress_event = "maximize";
            match = { class = ".*"; };
          }
          {
            name = "fix-xwayland-drags";
            no_focus = true;
            match = {
              class = "^$";
        	    title = "^$";
        	    xwayland = true;
        	    float = true;
        	    fullscreen = false;
        	    pin = false;
            };

          }
          {
            name = "move-hyprland-run";
            move = "20 monitor_h-120";
            float = true;
            match = { class = "hyprland-run"; };
          }
        ];

        mod = { _var = "SUPER"; };
        editor = { _var = "emacs"; };
        browser = { _var = "firefox"; };
        terminal = { _var = "ghostty -e fish"; };
        terminalAlt = { _var = "alacritty"; };
        fileManager = { _var = "ghostty -e yazi"; };
        launcher = { _var = "noctalia msg panel-toggle launcher"; };
        emojis = { _var = "noctalia msg panel-toggle launcher /emo"; };
        wallpaper = { _var = "noctalia msg panel-toggle wallpaper"; };
        wallpaperRandom = { _var = "noctalia msg wallpaper-random"; };
        screenshot = { _var = "noctalia msg screenshot-fullscreen"; };
        screenshotRegion = { _var = "noctalia msg screenshot-region"; };

        bind = [
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + Q\"")
              (lib.generators.mkLuaInline "hl.dsp.window.close()")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + RETURN\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminal)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + RETURN\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminalAlt)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + E\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(editor)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + B\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(browser)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + F\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(fileManager)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + D\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(launcher)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + J\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(emojis)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + W\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(wallpaperRandom)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + W\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(wallpaper)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + S\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(screenshot)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + S\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(screenshotRegion)")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + M\"")
              (lib.generators.mkLuaInline
                "hl.dsp.exec_cmd(\"command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'\")")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + V\"")
              (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + P\"")
              (lib.generators.mkLuaInline "hl.dsp.window.pseudo()")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + left\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + right\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"right\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + up\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + down\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
            ];
          }
        ];

        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline
              "function() hl.exec_cmd('noctalia') end")
            (lib.generators.mkLuaInline
              "function() hl.exec_cmd('wl-clip-persist --clipboard-regular') end")
          ];
        };
      };

      extraConfig = ''
        for i = 1, 10 do
            local key = i % 10
            hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
            hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
        hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
        hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
        hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
      '';
    };
  };
}
