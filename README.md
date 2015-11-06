# Install Intel C/C++ Compiler on Travis CI

**THIS DOES NOT WORK YET**.  I'm working on it.  If you want to be
notified when it does work, subscribe to notifications for
[issue #1](https://github.com/nemequ/icc-travis/issues/1).

This project is intended to provide an easy way to use Intel's
[silent installer](https://software.intel.com/en-us/articles/intel-composer-xe-2015-silent-installation-guide)
to install ICC (and/or other components from Parallel Studio) on
Travis.

This script was originally written for
[Squash](https://quixdb.github.io/squash).

## Usage

The script requires the `INTEL_SERIAL_NUMBER` environment variable be
set to your serial number.  *Do not include your serial number in your
repository*.  Instead, you can take advantage of Travis' support for
[secure environment variables](http://docs.travis-ci.com/user/encryption-keys/).

Once you have your serial number in the INTEL_SERIAL_NUMBER
environment variable, all you need to do is run the `install-icc.sh`
script.  There are two main ways to go about that: you can copy the
`install-icc.sh` script to your repository, or download the latest
version from GitHub every time you want to run it.

The main advantage of placing a copy of `install-icc.sh` in your repo
is stability; you know the script is not going to change in a way that
breaks backwards compatibility.  On the other hand, stability can also
be a disadvantage; you will not be able to take advantage of bug fixes
and new versions automatically.

Downloading a copy of the script every time you run it is less stable,
but it means you always get the latest version.  For example, the
script should be updated soon after Intel releases a new version of
ICC, and your software will automatically start using it to build.

If you choose to have travis download a copy every time, you can use
this command:

```bash
wget -q -O /dev/stdout \
  'https://raw.githubusercontent.com/nemequ/icc-travis/master/install-icc.sh' | \
  /bin/sh
```

### Arguments

Currently, there are three arguments you can pass:

 - `--dest`: Location to install to.  Default: /opt/intel
 - `--tmpdir`: Location for temporary files.  Default: /tmp
 - `--components`: comma-separated list of components to install. Valid components are:

   - icc
   - mpi
   - vtune
   - inspector
   - advisor
   - openmp
   - tbb
   - ifort
   - mkl
   - ipp
   - ipp-crypto
   - gdb

   If you do not pass a component argument, the "icc" component and
   *only* the "icc" component is installed.  If you do pass a
   component then icc will no longer be intalled by default (mainly
   useful if you want to use FORTRAN not C).

Use a space to separate argument names from values (*i.e.*, `--dest
/opt/foo` not `--dest=/opt/foo`.

## Restrictions

ICC is *not* free software.  It's proprietary (and expensive).  Intel
very graciously [provides people developing open-source projects with
free licenses](https://software.intel.com/en-us/qualify-for-free-software/opensourcecontributor),
but there are some restrictions.  Make sure your usage complies with
their restrictions, and do not abuse it.  Basically, don't do anything
to screw this up for the rest of us.

## License

To the extent possible under law, the author(s) of this script have
waived all copyright and related or neighboring rights to this work.
For details, see the
[CC0 1.0 Universal Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/) for details.
