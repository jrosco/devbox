# Docker Devbox

A development environment containing:

* Vim
* C/C++ compilers and tools
* Golang compilers and tools
* Python and tools
* git
* tmux
* ssh
* Docker (inception)

The devbox is as stateless as possible, every dev done inside it is
doomed to be destroyed, unless pushed to an external Git
repository. The idea is to be able fire up a known environment on a
new box, without spending 3 hours to figure out what is needed.

## Build
-----

### Clone into your home directory

```bash
git clone https://github.com/jrosco/docker-devbox.git $HOME/docker-devbox
```

### Setup an alias

```bash
alias devbox="cd $HOME/docker-devbox/ ; make $@"
```

### Build Docker Image

This process can take some time

```bash
cd ./docker-devbox
make all
```

## Usage

_Assumes you have setup the above alias_

### Run Docker Image

```bash
devbox run
```

### Log into the Docker Image

```bash
devbox logon
```

### Stop Process

```bash
devbox stop
```

### Stop and Destroy Process

```bash
devbox clean
```

### List running Docker Image and Processes

```bash
devbox list-running
```

This is a personnal Devbox, without my own set of configs and
tools. If you want to use it, fork it and edit your configuration
files to your needs.
