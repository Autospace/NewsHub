#!/bin/bash


set -eo pipefail

xcodebuild -workspace NewsHub/NewsHub.xcworkspace \
            -scheme NewsHub \
            -destination platform=iOS\ Simulator,OS=13.7,name=iPhone\ 11 \
            clean test | xcpretty