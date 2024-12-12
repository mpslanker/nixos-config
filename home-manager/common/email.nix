{
  lib,
  pkgs,
  username,
  fullname,
  useremail,
  workemail,
  ...
}:
{
    programs.himalaya = {
        enable = true;
    };
}