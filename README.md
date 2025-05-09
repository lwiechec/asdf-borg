<div align="center">

# asdf-borg [![Build](https://github.com/lwiechec/asdf-borg/workflows/Build/badge.svg)](https://github.com/lwiechec/asdf-borg/actions/workflows/build.yml) [![Lint](https://github.com/lwiechec/asdf-borg/workflows/Lint/badge.svg)](https://github.com/lwiechec/asdf-borg/actions/workflows/lint.yml)

[borg](https://github.com/borgbackup/borg) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add borg https://github.com/lwiechec/asdf-borg.git
```

borg:

```shell
# Show all installable versions
asdf list all borg

# Install specific version
asdf install borg latest

# Set a version globally (on your ~/.tool-versions file)
asdf set -u borg latest

# Now babashka commands are available
borg --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/lwiechec/asdf-borg/graphs/contributors)!

# Thanks

This repository is adapted from [adsf-babashka](https://github.com/fredZen/asdf-babashka) by
[Frederic Merizen](https://github.com/fredZen).

# License

Distributed under the [Eclipse Public License](LICENSE), the same as [adsf-babashka](https://github.com/fredZen/asdf-babashka).
© [Lukasz Wiechec](https://github.com/lwiechec/)
