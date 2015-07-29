#!/usr/bin/perl
#
# Copyright (C) 2015 Rodolphe Quiédeville <rodolphe@quiedeville.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License

# Update the blockingJobs value
#
# <properties>
#   <hudson.plugins.buildblocker.BuildBlockerProperty plugin="build-blocker-plugin@1.4.1">
#     <useBuildBlocker>true</useBuildBlocker>
#     <blockingJobs>People.*</blockingJobs>
#   </hudson.plugins.buildblocker.BuildBlockerProperty>
#   <com.coravy.hudson.plugins.github.GithubProjectProperty plugin="github@1.9.1">
#     <projectUrl>https://github.com/novapost/perf-scenarii/</projectUrl>
#   </com.coravy.hudson.plugins.github.GithubProjectProperty>
# </properties>
#
#
use strict;
use warnings;
use XML::LibXML;

# Read filename as commande line argument
my $filename = shift() or die "Please indicate a filename !\n",

# script to be used
my $file_script = 'blockingJobs.txt';

open my $fh, '<', $filename or die "error opening $filename: $!";
my $data = do { local $/; <$fh> };

# Parse the file read
my $p = XML::LibXML->new;
my $d = $p->parse_string($data);

# remove the Build node
my $params  = $d->findnodes('/project/properties/hudson.plugins.buildblocker.BuildBlockerProperty');
foreach my $node ($params->[0]->childNodes()) {
    $params->[0]->removeChild($node) if ($node->nodeName =~ "blockingJobs");
}

# Read the content of the new Groovy Build node
open my $fs, '<', 'blockingJobs.txt' or die "error opening $file_script: $!";
my $script = do { local $/; <$fs> };

my $script_el = $d->ownerDocument->createElement('blockingJobs');
my $sb = $d->createTextNode($script);
$params->[0]->appendChild( $script_el );
$script_el->appendChild( $sb );
#
#
#
# Write new file to disk
#
open (FO, ">$filename");
print FO $d;
close(FO);
