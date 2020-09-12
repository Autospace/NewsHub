#!/bin/bash


set -eo pipefail

xcodebuild -workspace NewsHub.workspace \
            -scheme NewsHub\ iOS \
            -destination platform=iOS\ Simulator,OS=13.4,name=iPhone\ 11 \
            clean test | xcpretty