# Xwift

A privacy-focused cryptocurrency forked from Monero, featuring faster block times while maintaining strong privacy guarantees.

Copyright (c) 2024, The Xwift Project
Portions Copyright (c) 2014-2024, The Monero Project

## Table of Contents

  - [Introduction](#introduction)
  - [Key Differences from Monero](#key-differences-from-monero)
  - [Quick Start](#quick-start)
  - [Network Configuration](#network-configuration)
  - [Compiling Xwift from Source](#compiling-xwift-from-source)
    - [Dependencies](#dependencies)
    - [Build Instructions](#build-instructions)
  - [Running xwiftd](#running-xwiftd)
  - [Wallet Operations](#wallet-operations)
  - [Using Tor](#using-tor)
  - [Pruning](#pruning)
  - [Debugging](#debugging)
  - [License](#license)
  - [Contributing](#contributing)

## Introduction

Xwift is a private, secure, untraceable, decentralized digital currency based on the Monero protocol. Like Monero, Xwift provides strong privacy guarantees through ring signatures, stealth addresses, and confidential transactions. Xwift operates as an independent blockchain with its own network identity and unique parameters.

**Privacy:** Xwift uses cryptographically sound systems to allow you to send and receive funds without your transactions being easily revealed on the blockchain. This ensures that your purchases, receipts, and all transfers remain private by default.

**Security:** Using the power of a distributed peer-to-peer consensus network, every transaction on the network is cryptographically secured. Individual wallets have a 25-word mnemonic seed that is only displayed once and can be written down to backup the wallet.

**Untraceability:** By taking advantage of ring signatures, Xwift ensures that transactions are not only untraceable but have an optional measure of ambiguity that ensures transactions cannot easily be tied back to an individual user or computer.

**Decentralization:** The utility of Xwift depends on its decentralized peer-to-peer consensus network - anyone can run the Xwift software, validate the integrity of the blockchain, and participate in all aspects of the Xwift network using consumer-grade commodity hardware.

## Key Differences from Monero

Xwift maintains Monero's privacy and security features while introducing key modifications:

- **Faster Block Times**: 30-second blocks (vs Monero's 120 seconds)
- **Unique Network Identity**: Independent network ID and genesis block
- **Custom Ports**: Mainnet uses 19080 (P2P), 19081 (RPC), 19082 (ZMQ)
- **Independent Blockchain**: Completely separate network from Monero
- **Address Prefix**: Different address format (prefix 65 for mainnet, 85 for testnet)
- **Development Fund**: 2% block reward for 1 year (1,051,200 blocks)

These changes create an independent cryptocurrency network that does not interact with the Monero blockchain.

## Quick Start

For detailed deployment instructions, including automated setup scripts and Docker deployment, see [README_XWIFT.md](README_XWIFT.md).

**Quick deployment:**
```bash
cd Xwift
sudo ./utils/scripts/deploy-xwift.sh
```

## Network Configuration

### Mainnet
- **P2P Port**: 19080
- **RPC Port**: 19081
- **ZMQ Port**: 19082
- **Address Prefix**: 65
- **Block Time**: 30 seconds

### Testnet
- **P2P Port**: 29080
- **RPC Port**: 29081
- **ZMQ Port**: 29082
- **Address Prefix**: 85
- **Block Time**: 30 seconds

**Important**: Xwift uses a completely unique network ID and genesis block. It will never connect to Monero nodes.

## Compiling Xwift from Source

### Dependencies

The following table summarizes the tools and libraries required to build. These are the same dependencies as Monero:

| Dep          | Min. version  | Debian/Ubuntu pkg    | Arch pkg     | Fedora pkg          | Purpose         |
| ------------ | ------------- | -------------------- | ------------ | ------------------- | --------------- |
| GCC          | 7             | `build-essential`    | `base-devel` | `gcc`               | Compiler        |
| CMake        | 3.10          | `cmake`              | `cmake`      | `cmake`             | Build system    |
| pkg-config   | any           | `pkg-config`         | `base-devel` | `pkgconf`           | Build system    |
| Boost        | 1.66          | `libboost-all-dev`   | `boost`      | `boost-devel`       | C++ libraries   |
| OpenSSL      | basically any | `libssl-dev`         | `openssl`    | `openssl-devel`     | sha256 sum      |
| libzmq       | 4.2.0         | `libzmq3-dev`        | `zeromq`     | `zeromq-devel`      | ZeroMQ library  |
| libunbound   | 1.4.16        | `libunbound-dev`     | `unbound`    | `unbound-devel`     | DNS resolver    |
| libsodium    | ?             | `libsodium-dev`      | `libsodium`  | `libsodium-devel`   | cryptography    |
| libunwind    | any           | `libunwind8-dev`     | `libunwind`  | `libunwind-devel`   | Stack traces    |
| liblzma      | any           | `liblzma-dev`        | `xz`         | `xz-devel`          | For libunwind   |
| libreadline  | 6.3.0         | `libreadline6-dev`   | `readline`   | `readline-devel`    | Input editing   |

Install all dependencies at once on Debian/Ubuntu:

```bash
sudo apt update && sudo apt install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libexpat1-dev libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev python3 ccache git
```

Install all dependencies at once on Arch:
```bash
sudo pacman -Syu --needed base-devel cmake boost openssl zeromq unbound libsodium libunwind xz readline expat python3 ccache hidapi libusb protobuf systemd
```

### Build Instructions

#### Cloning the repository

Clone recursively to pull-in needed submodule(s):

```bash
git clone --recursive https://github.com/YOUR_USERNAME/Xwift
cd Xwift
```

If you already have a repo cloned, initialize and update:

```bash
cd Xwift && git submodule init && git submodule update
```

#### On Linux and macOS

* Install the dependencies (see above)
* Change to the root of the source code directory and build:

    ```bash
    cd Xwift
    make release
    ```

    *Optional*: If your machine has several cores and enough memory, enable
    parallel build by running `make release -j<number of threads>` instead of `make release`. For
    this to be worthwhile, the machine should have one core and about 2GB of RAM
    available per thread.

* The resulting executables can be found in `build/release/bin`:
  - `xwiftd` - The daemon
  - `xwift-wallet-cli` - Command-line wallet
  - `xwift-wallet-rpc` - RPC wallet server

* **Optional**: build and run the test suite to verify the binaries:

    ```bash
    make release-test
    ```

    *NOTE*: `core_tests` may take a few hours to complete.

* **Optional**: to build binaries suitable for debugging:

    ```bash
    make debug
    ```

#### On Windows

Binaries for Windows can be built on Windows using the MinGW toolchain within
[MSYS2 environment](https://www.msys2.org).

**Preparing the build environment**

* Download and install the [MSYS2 installer](https://www.msys2.org)
* Open the MSYS shell via the `MSYS2 MSYS` shortcut
* Update packages using pacman:

    ```bash
    pacman -Syu
    ```

* Install dependencies:

    ```bash
    pacman -S mingw-w64-x86_64-toolchain make mingw-w64-x86_64-cmake mingw-w64-x86_64-boost mingw-w64-x86_64-openssl mingw-w64-x86_64-zeromq mingw-w64-x86_64-libsodium mingw-w64-x86_64-hidapi mingw-w64-x86_64-unbound
    ```

**Building**

* Open the MinGW shell via `MSYS2 MINGW64` shortcut
* Clone and build:

    ```bash
    git clone --recursive https://github.com/YOUR_USERNAME/Xwift
    cd Xwift
    make release-static -j $(nproc)
    ```

   The resulting executables can be found in `build/release/bin`

## Running xwiftd

The build places the binary in `build/release/bin/` sub-directory. To run in the
foreground:

```bash
./build/release/bin/xwiftd
```

To list all available options, run `./build/release/bin/xwiftd --help`. Options can be
specified either on the command line or in a configuration file passed by the
`--config-file` argument.

To run in background:

```bash
./build/release/bin/xwiftd --log-file xwiftd.log --detach
```

### Mainnet vs Testnet

By default, `xwiftd` runs on mainnet. To run on testnet:

```bash
./build/release/bin/xwiftd --testnet
```

## Wallet Operations

### Creating a Mainnet Wallet

```bash
./build/release/bin/xwift-wallet-cli --generate-wallet my-wallet
```

### Creating a Testnet Wallet

```bash
./build/release/bin/xwift-wallet-cli --testnet --generate-wallet my-test-wallet
```

### Connecting to Remote Node

```bash
./build/release/bin/xwift-wallet-cli --daemon-address node.xwift.org:19081
```

**Important**: When connecting to remote nodes, use `--untrusted-daemon` for additional security checks.

## Using Tor

While Xwift isn't made to integrate with Tor, it can be used wrapped with torsocks, by
setting the following configuration parameters:

* `--p2p-bind-ip 127.0.0.1` on the command line or `p2p-bind-ip=127.0.0.1` in
  xwiftd.conf to disable listening for connections on external interfaces.
* `--no-igd` on the command line or `no-igd=1` in xwiftd.conf to disable IGD
  (UPnP port forwarding negotiation), which is pointless with Tor.
* If you use the wallet with a Tor daemon via the loopback IP (eg, 127.0.0.1:9050),
  then use `--untrusted-daemon` unless it is your own hidden service.

Example command line to start xwiftd through Tor:

```bash
xwiftd --proxy 127.0.0.1:9050 --p2p-bind-ip 127.0.0.1 --no-igd
```

## Pruning

As the Xwift blockchain grows, you can store a pruned blockchain to save disk space.
A pruned blockchain can only serve part of the historical chain data to other peers, but is otherwise identical in
functionality to the full blockchain.

To use a pruned blockchain, start the initial sync with `--prune-blockchain`:

```bash
xwiftd --prune-blockchain
```

It is also possible to prune an existing blockchain using the `xwift-blockchain-prune` tool.

## Debugging

This section contains general instructions for debugging failed installs or problems encountered with Xwift.

### Obtaining stack traces on Unix systems

We generally use the tool `gdb` (GNU debugger) to provide stack trace functionality:

* To use `gdb` to obtain a stack trace for a stalled build:

Run the build. Once it stalls, enter:

```bash
gdb /path/to/xwiftd `pidof xwiftd`
```

Type `thread apply all bt` within gdb to obtain the stack trace.

### Analysing memory corruption

Configure Xwift with the -D SANITIZE=ON cmake flag:

```bash
cd build/debug && cmake -D SANITIZE=ON -D CMAKE_BUILD_TYPE=Debug ../..
make
```

You can then run the Xwift tools normally. Performance will typically halve.

## License

See [LICENSE](LICENSE).

Xwift is based on Monero and maintains compatibility with the BSD-3-Clause license. We acknowledge and thank the Monero Project and all contributors to the upstream codebase.

## Contributing

Contributions to Xwift are welcome! If you have a fix or code change, feel free to submit it as a pull request to the "master" branch. For large or complex changes, please discuss them in advance through GitHub issues.

**Please ensure that:**
- Your code follows existing style conventions
- You've tested your changes on testnet before submitting
- You include clear commit messages describing your changes
- You update documentation as needed

## Acknowledgments

Xwift is built on the excellent foundation provided by:
- **The Monero Project** - For the core privacy protocol and implementation
- **The CryptoNote developers** - For the original CryptoNote protocol
- All open-source contributors to privacy-focused cryptocurrency development

## Support & Resources

- **Deployment Guide**: See [README_XWIFT.md](README_XWIFT.md) for comprehensive deployment instructions
- **GitHub Issues**: Report bugs and request features via GitHub
- **Testing**: Always test on testnet before deploying to mainnet

---

**Xwift: Privacy-focused cryptocurrency with faster block times** 🚀
