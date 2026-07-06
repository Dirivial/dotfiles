{ pkgs, ... }:

let
  catppuccinYazi = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "main";
    sha256 = "sha256-L6SApM07CSQk0znEsFP8WaxW+ZHcindXo612r1XcwIg=";
  };
in
{
  home.packages = with pkgs; [
    yazi
  ];

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=CatppuccinMochaBlue
  '';

  xdg.configFile."yazi/theme.toml".source =
    "${catppuccinYazi}/themes/mocha/catppuccin-mocha-blue.toml";

  xdg.dataFile."color-schemes/CatppuccinMochaBlue.colors".text = ''
    [ColorEffects:Disabled]
    Color=29, 32, 48
    ColorAmount=0.30000000000000004
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=0
    IntensityAmount=-1
    IntensityEffect=0

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=29, 32, 48
    ColorAmount=0.5
    ColorEffect=3
    ContrastAmount=0
    ContrastEffect=0
    Enable=true
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=137, 180, 250
    BackgroundNormal=69, 71, 90
    DecorationFocus=137, 180, 250
    DecorationHover=69, 71, 90
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=137, 180, 250
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Complementary]
    BackgroundAlternate=24, 24, 37
    BackgroundNormal=30, 30, 46
    DecorationFocus=137, 180, 250
    DecorationHover=69, 71, 90
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=137, 180, 250
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Header]
    BackgroundAlternate=24, 24, 37
    BackgroundNormal=30, 30, 46
    DecorationFocus=137, 180, 250
    DecorationHover=69, 71, 90
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=137, 180, 250
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Selection]
    BackgroundAlternate=137, 180, 250
    BackgroundNormal=137, 180, 250
    DecorationFocus=137, 180, 250
    DecorationHover=69, 71, 90
    ForegroundLink=137, 180, 250
    ForegroundInactive=30, 30, 46
    ForegroundActive=250, 179, 135
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=24, 24, 37
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Tooltip]
    BackgroundAlternate=17, 17, 27
    BackgroundNormal=29, 32, 48
    DecorationFocus=137, 180, 250
    DecorationHover=69, 71, 90
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=137, 180, 250
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:View]
    BackgroundAlternate=49, 50, 68
    BackgroundNormal=30, 30, 46
    DecorationFocus=137, 180, 250
    DecorationHover=69, 71, 90
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=137, 180, 250
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [Colors:Window]
    BackgroundAlternate=24, 24, 37
    BackgroundNormal=30, 30, 46
    DecorationFocus=137, 180, 250
    DecorationHover=69, 71, 90
    ForegroundActive=250, 179, 135
    ForegroundInactive=166, 173, 200
    ForegroundLink=137, 180, 250
    ForegroundNegative=243, 139, 168
    ForegroundNeutral=249, 226, 175
    ForegroundNormal=205, 214, 244
    ForegroundPositive=166, 227, 161
    ForegroundVisited=203, 166, 247

    [General]
    ColorScheme=CatppuccinMochaBlue
    Name=Catppuccin Mocha Blue
    accentActiveTitlebar=false
    shadeSortColumn=true

    [KDE]
    contrast=4

    [WM]
    activeBackground=30, 30, 46
    activeBlend=205, 214, 244
    activeForeground=205, 214, 244
    inactiveBackground=24, 24, 37
    inactiveBlend=166, 173, 200
    inactiveForeground=166, 173, 200
  '';
}
