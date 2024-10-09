# Introduction to Chapel

[Chapel](https://chapel-lang.org/) is a programming language for productive parallel computing. This repository contains code from the [ChapelCon 2024](https://chapel-lang.org/ChapelCon24.html) Chapel tutorial. The [slides](https://chapel-lang.org/ChapelCon/2024/chapel-tutorial.pdf) and [video recording](https://www.youtube.com/watch?v=N2LWN3A9rck) are also available.

To get started with this template, you can either use [GitHub Codespaces](#using-a-codespace) or your own machine (via [Docker](#using-docker) or by [building from source](#building-chapel-from-source-on-your-machine)).

The files in this repository correspond to files in the tutorial slide deck.
They are listed with numerical prefixes (e.g., `01-heat-1D-serial.chpl`)
that represent the order in which they appear in the slides.

## Learning Resources
To learn about Chapel beyond what's presented in the slides, consider the
following resources:

* For Chapel’s core features, check out the [Advent of Code](https://chapel-lang.org/blog/series/advent-of-code-2022/) blog series
* For more information on Chapel’s various loops, including ‘forall’, check out the [Loops primer](https://chapel-lang.org/docs/primers/loops.html)
* For details on Chapel's GPU support, see [Introduction to GPU Programming](https://chapel-lang.org/blog/posts/intro-to-gpus/)

For a broader list of resources, check out the [Learning Chapel](https://chapel-lang.org/learning.html) page on the Chapel website.

## Using a Codespace

> :warning: Because Codespaces are a virtualized environment running on shared hardware with a modest core count, don't expect parallelism or performance observed here to be reflective of what a native installation of Chapel can achieve.

This repo includes a `devcontainer.json` file, making it usable from GitHub Codespaces. When viewing this repository from GitHub's UI, click __Use this template > Open in a codespace__ to get started. The codespace includes the Visual Studio Code extension for Chapel, and tools such as [`chpl-language-server`](https://chapel-lang.org/docs/main/tools/chpl-language-server/chpl-language-server.html) and [`chplcheck`](https://chapel-lang.org/docs/main/tools/chplcheck/chplcheck.html).

In the Codespace, compile Chapel programs using the __Terminal__ tab by using the `chpl` compiler:

```bash
chpl 01-heat-1D-serial.chpl
./01-heat-1D-serial
```

### Simulating Multiple Nodes
Although the Codespace is set to a single-locale (single-node) mode by default, you can simulate multiple nodes by setting the `CHPL_COMM` environment variable to `gasnet` when compiling.

```bash
# Compile a program that distributes computation to multiple nodes
CHPL_COMM=gasnet chpl 07-heat-1D-block.chpl

# Run hello using two simulated nodes
./07-heat-1D-block -nl 2
```

To avoid having to include `CHPL_COMM` in each compilation command, you can
`export` it:

```bash
export CHPL_COMM=gasnet
chpl 07-heat-1D-block.chpl
./07-heat-1D-block -nl 2
```

### Simulating GPU Support
GitHub codespaces do not have GPUs available to them. However, Chapel
provides a mode called ["CPU-as-device"](https://chapel-lang.org/docs/technotes/gpu.html#cpu-as-device-mode),
which mocks GPU support by running GPU-eligible loops on the CPU. To enable
this mode, set the `CHPL_LOCALE_MODEL` to `gpu` (to enable GPU support)
and `CHPL_GPU` to `cpu` to select "CPU-as-device" mode.

```bash
CHPL_LOCALE_MODEL=gpu CHPL_GPU=cpu chpl 06-heat-1D-gpu.chpl
```

## Using Docker

Install Docker (see the [Installing Docker](#installing-docker) section below for suggestions). Then, use the following command:

```bash
docker pull docker.io/chapel/chapel-gasnet
```

Next follow the instructions at https://hub.docker.com/r/chapel/chapel to compile a hello world in Chapel, but use the `chapel-gasnet` container and when you run the “hello” executable specify `-nl 1`.  Here are the commands to use:

```
echo 'writeln("Hello, world!");' > hello.chpl

docker run --rm -it -v "$PWD":/myapp -w /myapp chapel/chapel-gasnet /bin/bash

root@xxxxxxxxx:/myapp# chpl hello.chpl
root@xxxxxxxxx:/myapp# ./hello -nl 1
Hello, world!
```

Note that the Chapel docker image with GASNet support does not have
any GPU-related support. To use GPU support, you might be better served
by [building from source](#building-chapel-from-source-on-your-machine) on
your own machine.

## Building Chapel from Source on Your Machine

Please follow the instructions on the [Download Chapel](https://chapel-lang.org/download.html) page to build the Chapel compiler and runtime from source and get set up with the Chapel compiler executable `chpl`. From there, you can compile and run the `01-heat-1D-serial.chpl` file in this repository as follows:

```bash
chpl 01-heat-1D-serial.chpl
./01-heat-1D-serial
```

To make use of multiple nodes (or to simulate multi-node execution), please
refer to [Multilocale Chapel Execution](https://chapel-lang.org/docs/usingchapel/multilocale.html).
To set up for Chapel's GPU support, refer to the [GPU Programming](https://chapel-lang.org/docs/technotes/gpu.html) tech note.

## Installing Docker

### Mac

Download the docker desktop for Intel or Arm as appropriate from
https://docs.docker.com/get-docker/.

Start up docker desktop.  You do not need a docker account.


### Linux

* First three steps on https://docs.docker.com/engine/install/ubuntu/
  1. Set up Docker's Apt repository.
    ```
      # Add Docker's official GPG key:
      sudo apt-get update
      sudo apt-get install ca-certificates curl gnupg
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      # Add the repository to Apt sources:
      echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg]   https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update
    ```

  2. Install the Docker packages.
    ```
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

  3. Verify that the Docker Engine installation is successful by running the hello-world image.
    ```
      sudo docker run hello-world
    ```


* Additional steps
    ```
      sudo groupadd docker
      sudo usermod -aG docker ${USER}

      # maybe not necessary
      sudo chmod 666 /var/run/docker.sock

    ```

### Windows

1. download docker for windows from: https://docs.docker.com/desktop/install/windows-install/
  a. when promted to log in or create an account, select continue without logging in

2. open a Powershell terminal (preferably as admin)
  a. if you don't have WSL installed, execute `wsl --install`
  b. next, ensure that your Ubuntu distro is using WSL2 (rather than WSL1).
  Execute `wsl -l -v` and ensure that ubuntu says 2 under version.
   i. If it is on version 1, execute `wsl --set-version ubuntu 2` (may take some time)

3. open the docker desktop app to start the docker daemon
  a. you can check that docker is using WSL Ubuntu by going to
  Settings > Resources > WSL Integration

4. in Powershell, execute docker pull chapel/chapel-gasnet

*NOTE*: For Windows you will probably have to replace the `$PWD` from the instructions
at https://hub.docker.com/r/chapel/chapel with the Windows version of the current path
written out
