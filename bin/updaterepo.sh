#! /bin/sh
#
# updatefigures.sh
# Copy png images from the vertical dolthub repository
# Copyright (C) 2020 jbustamante <jbustamante@wisc.edu>
#
# Distributed under terms of the MIT license.
#

vertical_dir="/home/jbustamante/Dropbox/Misc/dataanalytics/vertical"
figures_dir="figures"
data="data.csv"

cp "$vertical_dir"/"$figures_dir"/*.png ../"$figures_dir"
cp "$vertical_dir"/"$data" ..
