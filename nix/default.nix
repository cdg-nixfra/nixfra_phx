with import <nixpkgs> { };

let
  # beam.interpreters.erlang_23 is available if you need a particular version
  packages = beam.packagesWith beam.interpreters.erlang;

  pname = "nixfra_phx";
  version = "0.0.1";
  sha256 = "@@GIT_SHA256@@";

  src =  pkgs.fetchgit {
    inherit sha256;
    url = "@@GIT_URL@@";
    rev = "@@GIT_REV@@";
  };

  # if using mix2nix you can use the mixNixDeps attribute
  mixNixDeps = import ./mix_deps.nix {
    inherit beamPackages lib;
  };

  #nodeDependencies = (pkgs.callPackage ./assets/default.nix { }).shell.nodeDependencies;

in packages.mixRelease {
  inherit src pname version mixNixDeps;
  # if you have build time environment variables add them here
  #MY_ENV_VAR="my_value";

  postBuild = ''
    mix test
    #ln -sf {nodeDependencies}/lib/node_modules assets/node_modules
    #npm run deploy --prefix ./assets

    echo "git_rev=@@GIT_REV@@" >priv/build.txt
    echo "git_sha256=@@GIT_SHA256@@" >>priv/build.txt

    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, phx.digest
    mix phx.digest --no-deps-check
  '';
}
