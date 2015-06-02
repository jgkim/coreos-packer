# CoreOS Packer

This is a [packer](https://packer.io/) template for [CoreOS](http://parallels.github.io/vagrant-parallels/). The template currently supports only for [Vagrant with Parallels](http://parallels.github.io/vagrant-parallels/) images, but other builders will be added soon.

## Getting Started with Vagrant and Parallels

### 1. Preparation

#### Install [Homebrew](http://brew.sh/)

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#### Install [Homebrew Cask](http://caskroom.io/)

    $ brew install caskroom/cask/brew-cask

#### Install [Parallels Desktop & Virtualization SDK](http://www.parallels.com/products/desktop/download/)

*You need an appropriate license to use Parallels Desktop & Virtualization SDK.*

    $ brew cask install parallels-desktop
    $ brew cask install parallels-virtualization-sdk

#### Install [Vagrant](http://www.vagrantup.com/downloads) & [Parallels Provider](http://parallels.github.io/vagrant-parallels/)

    $ brew cask install vagrant
    $ vagrant plugin install vagrant-parallels

#### Install [Packer](https://packer.io/downloads.html)

    $ brew cask install packer

### 2. Build a Vagrant Box

    $ git clone https://github.com/jgkim/coreos-packer.git
    $ cd coreos-packer
    $ packer build -var 'channel=stable' -var 'version=647.2.0' -var 'checksum=adef94fabf7c3573b37b35fc7cf7ff2c' coreos.json

### 3. Add the Box to Vagrant

    $ vagrant box add --force --provider=parallels -name {name}/coreos-stable builds/stable/647.2.0/coreos_production_vagrant_parallels.box

### 4. Vagrant Up

    $ vagrant init {name}/coreos-stable
    $ vagrant up
    $ vagrant ssh

## Known Issues

- Building images fails from time to time due to [coreos/bugs#152](https://github.com/coreos/bugs/issues/152).
- [Vagrant Cloud Post-Processor](https://packer.io/docs/post-processors/vagrant-cloud.html) has some [bugs](https://github.com/mitchellh/packer/issues/1735) in the latest release (0.7.5), but works properly with [the recent code](https://github.com/mitchellh/packer).
- There are [bugs](https://github.com/mitchellh/packer/pull/2161) regarding use of `only` or `except` configurations in post-processors.
- ~~The [version description](https://github.com/mitchellh/packer/pull/2110) option in Vagrant Cloud Post-Processor is not interpolated with template variables.~~
- ~~[Atlas Post-Processor](https://packer.io/docs/post-processors/atlas.html) also works [only](https://github.com/mitchellh/packer/issues/1815) with the [development](https://github.com/mitchellh/packer) version of Packer, and it does not use the [interpolation](https://github.com/mitchellh/packer/issues/2048) in metadata blocks.~~
