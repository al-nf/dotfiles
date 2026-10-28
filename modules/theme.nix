let
  defaultThemeName = "jingliu";
  themes = [
    {
      name = "jingliu";
      image = "jingliu.jpg";
      colors = [
        "#cceaff"
        "#52b6ff"
      ];
    }
    {
      name = "acheron";
      image = "acheron.jpg";
      colors = [
        "#cba6f7"
        "#b4befe"
      ];
    }
    {
      name = "bina";
      image = "bina.png";
      colors = [
        "#8888ff"
        "#abbcda"
      ];
    }
    {
      name = "furina1";
      image = "furina1.png";
      colors = [
        "#abbcda"
        "#77eeee"
      ];
    }
    {
      name = "furina2";
      image = "furina2.png";
      colors = [
        "#ff99bb"
        "#abbcda"
      ];
    }
    {
      name = "arle0";
      image = "arle0.png";
      colors = [
        "#ff5544"
        "#ffaaaa"
      ];
    }
    {
      name = "arle1";
      image = "arle1.png";
      colors = [
        "#ff5544"
        "#ffaaaa"
      ];
    }
    {
      name = "arle2";
      image = "arle2.png";
      colors = [
        "#ff5544"
        "#ffaaaa"
      ];
    }
    {
      name = "chisa0";
      image = "chisa0.png";
      colors = [
        "#ff5544"
        "#ed44ff"
      ];
    }
    {
      name = "hiyuki0";
      image = "hiyuki0.png";
      colors = [
        "#ff5544"
        "#abbcda"
      ];
    }
    {
      name = "hiyuki1";
      image = "hiyuki1.png";
      colors = [
        "#ff5544"
        "#abbcda"
      ];
    }
  ];
in
{
  inherit defaultThemeName themes;
  defaultTheme = builtins.head (builtins.filter (theme: theme.name == defaultThemeName) themes);
  wallpaperDirectory = "Pictures/walls";
  borderAngle = 45;

  font = {
    family = "JetBrainsMono Nerd Font";
    size = 12;
  };

  colors = {
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
    surface0 = "#313244";
    surface1 = "#45475a";
    surface2 = "#585b70";
    overlay0 = "#6c7086";
    text = "#cdd6f4";
    subtext0 = "#a6adc8";
    subtext1 = "#bac2de";
    rosewater = "#f5e0dc";
    mauve = "#cba6f7";
    lavender = "#b4befe";
    sapphire = "#74c7ec";
    red = "#f38ba8";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    blue = "#89b4fa";
    pink = "#f5c2e7";
    teal = "#94e2d5";
    brightText = "#f5f1ed";
    inactiveBorder = "#595959";
    shadow = "#1a1a1a";
  };
}
