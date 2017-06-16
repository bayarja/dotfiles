#!/usr/bin/env bash

if [ "$(defaults read com.apple.finder AppleShowAllFiles)" == 'TRUE' ]; then
    defaults write com.apple.finder AppleShowAllFiles FALSE
else
    defaults write com.apple.finder AppleShowAllFiles TRUE
fi

killall Finder
exit 0
