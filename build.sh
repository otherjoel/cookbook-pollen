#!/bin/bash

cd cookbook
mkdir -p ../publish
raco pollen render *.html.pm && raco pollen publish . ../publish
