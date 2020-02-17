#!/usr/bin/env bash

TSV=$1

ITEMS=$( cat $TSV | cut -f2 )

echo $ITEMS >&2

IFS=',' read -r -a FOO <<< $ITEMS

echo "${FOO[0]}" >&2