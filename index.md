---
title: "grinc: an include file preprocessor"
layout: withTOC
---

# Introduction

*grinc* runs an include file preprocessor on one or more files, writing the
result to an output file (or standard output). It uses the
`Grizzled::FileUtil::Includer` class in the [Grizzled Ruby][] gem.

For a complete description, see the [man page][].

It can be installed as a [gem][rubygems].

# Installation

## From RubyGems.org

*grinc* is a [published gem][]. To install, make sure [rubygems][]
is installed, then run this command. (You may need to run it as *root*,
depending on your permissions, whether you're using [rvm][], etc.)

    $ gem install grinc

## From source

First, ensure that you have both `rubygems` and `rake` installed. Then, either
clone the [git repository][] or [download the source][] and unpack it. Then:

    $ cd grinc
    $ rake install
    
# Documentation

The [man page][] is available on this site, but it is also installed with
the gem. If you install the [gem-man][] gem, you can read the man page with:

    $ gem man grinc
    
If you alias your *man* command, as follows, then gem manual pages will be
seamlessly integrated into your regular system manual pages:

    $ alias man='gem man -s'
    $ man ls    # works!
    $ man grinc # works!

# Author

Brian M. Clapper, [bmc@clapper.org][]

# Copyright and License

*grinc* is copyright &copy; 2011 Brian M. Clapper
and is released under a [BSD License][].

# Change Log

The [change log][CHANGELOG] is [here][CHANGELOG].

# Patches

I gladly accept patches from their original authors. Feel free to email
patches to me or to fork the [git repository][] and send me a pull
request. Along with any patch you send:

* Please state that the patch is your original work.
* Please indicate that you license the work to the *grinc* project
  under a [BSD License][].

[BSD License]: license.html
[git repository]: http://github.com/bmc/grinc
[GitHub]: http://github.com/bmc/
[downloads area]: http://github.com/bmc/grinc/downloads
[bmc@clapper.org]: mailto:bmc@clapper.org
[rubygems]: http://rubygems.org/
[published gem]: https://rubygems.org/gems/grinc
[rvm]: http://rvm.beginrescueend.com/
[download the source]: https://github.com/bmc/grinc/archives/master
[CHANGELOG]: CHANGELOG.html
[man page]: man/grinc.1.html
[gem-man]: https://github.com/defunkt/gem-man
