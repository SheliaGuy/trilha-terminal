#!/usr/bin/env bash
awk '$7+0 > 1000' "$1" | wc -l
