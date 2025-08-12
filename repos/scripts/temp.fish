#! /bin/fish

sensors k10temp-pci-00c3 | tail -n 2 | head -n 1 | awk '{print $2}'
