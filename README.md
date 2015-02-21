jenkins-scripts
===============

Perl scripts to manage jenkins jobs config files

jobs.pl read a `config.xml` file and replaces parts of it. Actually it
just replace **postbuild script** section, with the content of
`gatling-assert.groovy`, feel free to fork and improve.


Depends
=======

* https://bitbucket.org/shlomif/perl-xml-libxml

* Debian package libxml-libxml-perl

Usage
=====

`$ perl jobs.pl config.xml`

Remember to reload configuration from disk each time you edit config
files, option *Reload Configuration from Disk* in *Manage jenkins* section.
