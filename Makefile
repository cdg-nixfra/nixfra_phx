.PHONY: package test

package:
	nix/build-package.sh

test:
	nix/test.sh
