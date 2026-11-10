#!/usr/bin/env bash

grep "ERROR" "$1" | awk '{print $5}' | sort | uniq -c | sort -nr
