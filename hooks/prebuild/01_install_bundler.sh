#!/bin/bash
dnf remove libpq-devel -y
dnf install postgresql17-devel -y
gem install bundler -v 2.5.6
