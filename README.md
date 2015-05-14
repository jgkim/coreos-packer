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

#### Install [Vagrant](http://www.vagrantup.com/downloads)

    $ brew cask install vagrant

#### Install [Packer](https://packer.io/downloads.html)

    $ brew cask install packer

### 2. Build a Vagrant Box

    $ git clone https://github.com/jgkim/coreos-packer.git
    $ cd coreos-packer
    $ packer build -var 'channel=stable' -var 'version=633.1.0' -var 'checksum=b08e074e7a0445772c81068989b1645b' coreos.json

### 3. Add the Box to Vagrant

    $ vagrant box add --force --provider=parallels -name {name}/coreos-stable builds/stable/633.1.0/coreos_production_vagrant_parallels.box

### 4. Vagrant Up

    $ vagrant init {name}/coreos-stable
    $ vagrant up
    $ vagrant ssh

## Known Issues

- Building images fails from time to time due to [coreos/bugs#152](https://github.com/coreos/bugs/issues/152)
