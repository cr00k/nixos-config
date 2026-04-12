# mandarina-home.nix
# Manages dotfiles, shell, editor, browser extensions, and GNOME settings

{ ... }:

{
  home.file."Pictures/wallpaper.jpg".source = ../../assets/wallpaper.jpg;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        extraOptions = {
          IdentityAgent = "none";
        };
      };
    };
  };
}





