#!/bin/bash

echo "Removing Log Files."
rm -rf *.log
echo "Removing tarballs."
rm -rf *.gz
rm -rf *.bz2
rm -rf testdir-*
echo "Finished"
