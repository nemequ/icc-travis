# Install Intel software tools on Travis CI

[![Build Status](https://travis-ci.org/nemequ/icc-travis.svg?branch=master)](https://travis-ci.org/jeffhammond/icc-travis)

This project is intended to provide an easy way to use Intel's
[silent installer](https://software.intel.com/en-us/articles/intel-composer-xe-2015-silent-installation-guide)
to install ICC (and/or other components from Parallel Studio) on
Travis.

This script was originally written for
[Squash](https://quixdb.github.io/squash).

## Usage

It is currently possible to use this script with either version of
Ubuntu which Travis currently supports (12.04 or 14.04), with or
without sudo.

Steps to using this script:

* Specify a serial number
* Run the script
* source ~/.bashrc
* Uninstall when finished (optional, but may help avoid an error due
  to too many activations).

### Specify a Serial Number

The script requires the `INTEL_SERIAL_NUMBER` environment variable be
set to your serial number.  *Do not include your serial number in your
repository*.  Instead, you can take advantage of Travis' support for
[secure environment variables](http://docs.travis-ci.com/user/encryption-keys/).

If you do not provide a serial number, the script will attempt to use
a trial license.  That seems to work sometimes, but sometimes it doesn't;
you probably shouldn't depend on it.  I'm also not sure what the legal
ramifications are.

#### Fast Path

This is the short version for those who don't want to click through.
```
gem install travis
cd $PATH_TO_PROJECT
travis encrypt INTEL_SERIAL_NUMBER=XXXX-XXXXXXX
```

After this, your terminal contains something like this:
```
secure: "xxxxxxxxxxxxxxxxxxxx"
```

Now you edit `.travis.yml` such that it looks like this:
```
language: c
sudo: false
env:
  global:
    - secure: "xxxxxxxxxxxxxxxxxxxx"
```

### Run the Script

Once you have your serial number in the INTEL_SERIAL_NUMBER
environment variable, you'll need to run the `install-icc.sh` script.
There are two main ways to go about that: you can copy the
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

#### Arguments

Currently, there are three arguments you can pass:

 - `--dest`: Location to install to.  Default: ${HOME}/intel
 - `--tmpdir`: Location for temporary files.  Default: /tmp

 - `--components`: comma-separated list of components to install.
   Default: icc. Valid components are:

   - icc
   - mpi
   - vtune
   - inspector
   - advisor
   - daal
   - tbb
   - ifort
   - mkl
   - ipp
   - ipp-crypto
   - gdb

If you do not pass a component argument, the "icc" component and
*only* the "icc" component is installed.  If you do pass a component
then icc will no longer be intalled by default (mainly useful if you
want to use FORTRAN not C).

If you have issues with other components please file a bug and we'll
try to work with you to make the process as smooth as possible.

Use a space to separate argument names from values (*i.e.*, `--dest
/opt/foo` not `--dest=/opt/foo`.

### Sourcing ~/.bashrc

Due to some oddities in how Travis works and Intel tools are set up, it's not
feasible to have the installer script set up the environment and have
that persist later in the build process.  The best we can do is write
some initialization data to ~/.bashrc for you to later source into
your environment.

To do this, simply add an entry to your .travis.yml some time after
you have invoked the installer but before you actually want to use
ICC.  For example:

```yaml
# ...
before_install:
 - ./install-icc.sh
script:
 - source ~/.bashrc
 - CC=icc CXX=icpc ./configure && make
# ...
```

### Uninstall

Some users have reported getting an error message about "Maximum
number of activations exceeded" (see
[issue #3](https://github.com/nemequ/icc-travis/issues/3)).  I haven't
been able to reproduce this, but
[according to Intel](https://software.intel.com/en-us/articles/what-to-do-when-you-see-the-message-maximum-number-of-activations-exceeded)
uninstalling existing installations should help.  Since we can't
access old containers/VMs, we need to proactively uninstall before the
container/VM is thrown away, which can be done by adding this to your
.travis.yml:

```yaml
after_script:
  - '[[ ! -z "${INTEL_INSTALL_PATH}" ]] && uninstall_intel_software'
```

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
[CC0 1.0 Universal Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/)
for details.

## Authors

[Evan Nemerson](https://github.com/nemequ) created this project.
[Jeff Hammond](https://github.com/jeffhammond) added tests for C++, Fortran and Intel performance libraries (e.g. MKL).
