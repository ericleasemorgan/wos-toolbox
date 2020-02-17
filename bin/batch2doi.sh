#!/usr/bin/env bash

# configure, get input, do the work
BATCH2DOI='./etc/batch2doi.xsl'
BATCH=$1
xsltproc $BATCH2DOI $BATCH
exit
