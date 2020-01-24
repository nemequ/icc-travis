# Instructions

The script that lives here doesn't really work anymore for most
licenses and hasn't been updated for newer versions of ICC, but there
is now a much easier way: use Intel's [APT
repository](https://software.intel.com/en-us/articles/oneapi-repo-instructions#aptpkg).

This integrates nicely with [Travis CI's APT
Addon](https://docs.travis-ci.com/user/installing-dependencies#installing-packages-with-the-apt-addon),
or you can [install it
manually](https://docs.travis-ci.com/user/installing-dependencies#installing-packages-without-an-apt-repository).

## Using Travis CI's APT Addon

You'll need to add the following to your `.travis.yml` file:

```yaml
addons:
  apt:
    sources:
    - sourceline: 'deb https://apt.repos.intel.com/oneapi all main'
      key_url: 'https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB'
    packages:
    - intel-oneapi-icc
```

If you would like an example, see [SIMDe's
`.travis.yml`](https://github.com/nemequ/simde/blob/master/.travis.yml)
