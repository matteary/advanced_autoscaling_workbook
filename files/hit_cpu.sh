#!/usr/bin/env bash

for i in {1..20}; do
    tmux -c yes > /dev/null &
done
