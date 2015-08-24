#!/bin/bash

# need an image build using "docker build -t decktape ." (in the dockerize folder)
docker run -v $(pwd):/custom-data -t decktape "$@"
