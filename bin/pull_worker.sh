#!/bin/bash

TAG=$(grep -e 'mumuki/mumuki-plunit-worker:[0-9]*\.[0-9]*' ./lib/prolog_runner.rb -o | tail -n 1)

echo "Pulling $TAG..."
docker pull $TAG
