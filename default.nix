with import <nixpkgs> { };

let
  # beam.interpreters.erlang_23 is available if you need a particular version
  packages = beam.packagesWith beam.interpreters.erlang;

  pname = "nixfra_phx";
  version = "0.0.1";

  src =  ./.;

  # if using mix2nix you can use the mixNixDeps attribute
  mixFodDeps = packages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    # nix will complain and tell you the right value to replace this with
    sha256 = "sha256-PmFAyEA8JigeTgApVrjvc8Ig+aTNGEgpIMFVFX3GEOc=";
    mixEnv = "prod"; # default is "prod", when empty includes all dependencies, such as "dev", "test".
    # if you have build time environment variables add them here
    # MY_ENV_VAR="my_value";
  };

  #nodeDependencies = (pkgs.callPackage ./assets/default.nix { }).shell.nodeDependencies;

in packages.mixRelease {
  inherit src pname version mixFodDeps;
  # if you have build time environment variables add them here
  #MY_ENV_VAR="my_value";

  postBuild = ''
    #ln -sf {nodeDependencies}/lib/node_modules assets/node_modules
    #npm run deploy --prefix ./assets

    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, phx.digest
    mix phx.digest --no-deps-check
  '';
}
