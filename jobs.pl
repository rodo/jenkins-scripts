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

use strict;
use warnings;
use XML::LibXML;

my $filename = shift() or die();

die("Please") unless $filename;

my $file_script = 'gatling-assert.groovy';

open my $fh, '<', $filename or die "error opening $filename: $!";
my $data = do { local $/; <$fh> };

my $p = XML::LibXML->new;
my $d = $p->parse_string($data);

my $params  = $d->findnodes('/project/publishers/org.jvnet.hudson.plugins.groovypostbuild.GroovyPostbuildRecorder/script');

foreach my $node ($params->[0]->childNodes()) {
    $params->[0]->removeChild($node) if ($node->nodeName =~ "script");    
}

open my $fs, '<', $file_script or die "error opening $filename: $!";
my $script = do { local $/; <$fs> };    

my $script_el = $d->ownerDocument->createElement('script');
my $sb = $d->createTextNode($script);
$params->[0]->appendChild( $script_el );
$script_el->appendChild( $sb );
#
#
#
my $command_script = 'command.xml';

if (-e $command_script) {

    $params  = $d->findnodes('/project/builders/hudson.tasks.Shell');
    
    foreach my $node ($params->[0]->childNodes()) {
        $params->[0]->removeChild($node) if ($node->nodeName =~ "command");    
    }

    open my $fs, '<', $command_script or die "error opening $filename: $!";
    my $script = do { local $/; <$fs> };    

    my $script_el = $d->ownerDocument->createElement('command');
    my $sb = $d->createTextNode($script);
    $params->[0]->appendChild( $script_el );
    $script_el->appendChild( $sb );
}

#
# Write new file to disk
#
open (FO, ">$filename");
print FO $d;
close(FO);
