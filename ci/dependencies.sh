#!/bin/bash

cd "$(dirname "$0")"/..
set -ex

cargo install cargo-hack

cargo tree
cargo tree --duplicate
cargo tree --duplicate || exit 1

# Check minimal versions.
# Remove dev-dependencies from Cargo.toml to prevent the next `cargo update`
# from determining minimal versions based on dev-dependencies.
cargo hack --remove-dev-deps --workspace
# Update Cargo.lock to minimal version dependencies.
cargo update -Zminimal-versions
cargo tree
cargo hack check --all --all-features --exclude benchmarks

exit 0
