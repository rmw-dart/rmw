#!/usr/bin/env bash
set -e
DIR=$( dirname $(realpath "$0") )
dart run build_runner build
