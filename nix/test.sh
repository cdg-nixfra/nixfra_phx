#!/usr/bin/env nix-shell
#! nix-shell -i bash -p elixir

base=$(cd $(dirname $0)/..; pwd)
cd $base

set -e

export MIX_ENV=test

mix local.hex --if-missing
mix local.rebar --if-missing

mix deps.get
mix test
