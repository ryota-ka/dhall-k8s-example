#/bin/bash -eu

for f in `ls ./*.dhall`; do
  nix-shell -p dhall --run "dhall-format --inplace $f"
done
