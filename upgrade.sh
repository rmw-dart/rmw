#!/usr/bin/env bash

set -e
_DIR=$(dirname $(realpath "$0"))
cd $_DIR

dart pub upgrade

