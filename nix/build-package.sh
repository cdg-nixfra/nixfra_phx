#!/usr/bin/env bash

base=$(cd $(dirname $0)/..; pwd)
cd $base

set -e

WORK=$(mktemp -d)

#trap "rm -rf $WORK" 0

# Collect info
git_url="file:///$PWD"
git_json=$(nix-prefetch-git --url "$git_url" --rev "$(git rev-parse --verify HEAD)" --quiet)
git_rev=$(echo "$git_json" | jq '.rev' -r)
git_sha256=$(echo "$git_json" | jq '.sha256' -r)

sed \
    -e "s,@@GIT_URL@@,$git_url," \
    -e "s,@@GIT_REV@@,$git_rev," \
    -e "s,@@GIT_SHA256@@,$git_sha256," \
    <nix/default.nix >$WORK/default.nix

chksum=$(sha256sum mix.lock)
grep -q "$chksum" mix_deps.nix 2>/dev/null || (
  nix-shell -p mix2nix --run mix2nix >mix_deps.nix
  echo "# $chksum" >>mix_deps.nix
)

cp mix_deps.nix $WORK


cd $WORK
nix-build .
