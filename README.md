# Install Intel C/C++ Compiler on Travis CI

**THIS DOES NOT WORK YET**.  I'm working on it.  If you want to be
notified when it does work, subscribe to notifications for
[issue #1](https://github.com/nemequ/icc-travis/issues/1).

This project is intended to provide an easy way to use Intel's
[silent installer](https://software.intel.com/en-us/articles/intel-composer-xe-2015-silent-installation-guide)
to install ICC on Travis.

This script was originally written for
[Squash](https://quixdb.github.io/squash).

## Usage

The script requires the `INTEL_SERIAL_NUMBER` environment variable be
set.  *Do not include your serial number in your repository*.
Instead, you can take advantage of Travis' support for
[secure environment variables](http://docs.travis-ci.com/user/encryption-keys/).

To use it, just copy the `install-icc.sh` script to your repository
(or you can wget the lastest version if you prefer.  Then, just
execute it.  Once it completes, you should have `icc` in your path.

Once this script is working you can use
[Squash](https://quixdb.github.io/squash) as an example.

## Restrictions

ICC is *not* free software.  It's proprietary (and expensive).  Intel
very graciously provides people developing open-source projects with
free licenses, but there are some restrictions.  Make sure your usage
complies with their restrictions, and do not abuse it.  Basically,
don't do anything to screw this up for the rest of us.

## License

To the extent possible under law, the author(s) of this script have
waived all copyright and related or neighboring rights to this work.
For details, see the
[CC0 1.0 Universal Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/) for details.
