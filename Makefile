

nix:
	#mix2nix > mix_deps.nix
	#nix-shell -p node2nix --run node2nix --development

build:
	nix-build .
