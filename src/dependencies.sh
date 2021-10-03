#!/bin/bash


echo 'This script will install all dependencies required.'

echo 'Thanks for installing DiveBar!'

install bundler
bundle install
gem update --system

