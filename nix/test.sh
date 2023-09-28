#!/usr/bin/env nix-shell
#! nix-shell -i bash -p elixir beamPackages.hex beamPackages.rebar3

base=$(cd $(dirname $0)/..; pwd)
cd $base

set -e

export MIX_ENV=test

mix deps.get
mix test
