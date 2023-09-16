
package: release
	nix/build-package.sh

release: deps
	MIX_ENV=prod mix compile
	MIX_ENV=prod mix assets.deploy
	MIX_ENV=prod mix release --overwrite

deps:
	mix deps.get
