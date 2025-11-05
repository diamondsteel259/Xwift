# Xwift

A privacy-focused cryptocurrency based on Monero technology, customized with unique network parameters and optimized for faster transactions while maintaining strong privacy guarantees.

Copyright (c) 2014-2024, The Monero Project
Copyright (c) 2025, The Xwift Project
Portions Copyright (c) 2012-2013 The Cryptonote developers.

## What is Xwift?

Xwift is a fork of Monero that maintains the same strong privacy and security features while implementing custom network configurations for improved performance. Like Monero, Xwift is a private, secure, untraceable, decentralized digital currency.

**Key Features:**
- **Privacy**: Cryptographically sound system ensures your transactions remain private by default
- **Security**: Distributed peer-to-peer consensus network secures every transaction
- **Untraceability**: Ring signatures ensure transactions cannot be tied back to individuals
- **Decentralization**: Run on consumer-grade hardware, no specialized equipment required
- **Faster Processing**: Optimized network parameters for improved transaction speeds

## Quick Links

- **Main Documentation**: [README_XWIFT.md](README_XWIFT.md) - Comprehensive Xwift-specific guide
- **Deployment Guide**: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Production deployment instructions
- **Repository**: https://github.com/diamondsteel259/Xwift
- **Based on**: [Monero Project](https://github.com/monero-project/monero)

## Network Configuration

### Mainnet
- **P2P Port**: 19080
- **RPC Port**: 19081
- **ZMQ Port**: 19082
- **Address Prefix**: 65

### Testnet
- **P2P Port**: 29080
- **RPC Port**: 29081
- **ZMQ Port**: 29082
- **Address Prefix**: 85

## Quick Start

### Automated Deployment
```bash
cd Xwift
sudo ./utils/scripts/deploy-xwift.sh
```

### Manual Build
```bash
# Install dependencies (Debian/Ubuntu)
sudo apt update && sudo apt install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libexpat1-dev libboost-all-dev

# Clone and build
git clone --recursive https://github.com/diamondsteel259/Xwift.git
cd Xwift
make release
```

### Running the Daemon
```bash
# Mainnet
./build/release/bin/xwiftd

# Testnet
./build/release/bin/xwiftd --testnet
```

### Creating a Wallet
```bash
# Mainnet wallet
./build/release/bin/xwift-wallet-cli --generate-wallet my-wallet

# Testnet wallet
./build/release/bin/xwift-wallet-cli --testnet --generate-wallet my-test-wallet
```

## Key Customizations from Monero

Xwift implements several critical customizations to ensure complete network independence:

1. **Unique Network Identity**: Separate network IDs for mainnet and testnet
2. **Custom Port Configuration**: Non-conflicting ports (19xxx/29xxx vs Monero's 18xxx/28xxx)
3. **Unique Address Prefixes**: Different addressing scheme from Monero
4. **Custom Genesis Blocks**: Independent blockchain genesis
5. **Optimized Parameters**: Performance improvements while maintaining security
6. **Custom Emission Curve**: Tailored block rewards and tail emission for optimal distribution

## Economic Model

### Block Rewards & Emission
- **Block Time:** 30 seconds (4× faster than Monero)
- **Initial Block Reward:** ~52.78 XWIFT per block
- **Tail Emission:** 0.9 XWIFT per block (perpetual)
- **Base Supply:** ~108.792 million XWIFT emitted over ~8.12 years
- **Total Supply:** Unlimited (tail emission continues forever)

### Emission Schedule

| Timeframe | Block Reward | Daily Emission | Annual Emission | Cumulative Supply |
|-----------|--------------|----------------|-----------------|-------------------|
| Genesis | 52.78 XWIFT | 152,006 XWIFT | 55.5M XWIFT | 52.78 XWIFT |
| Year 1 | ~38.63 XWIFT | ~111,254 XWIFT | ~40.6M XWIFT | ~43.06M XWIFT |
| Year 2 | ~28.27 XWIFT | ~81,418 XWIFT | ~29.7M XWIFT | ~64.54M XWIFT |
| Year 4 | ~15.13 XWIFT | ~43,574 XWIFT | ~15.9M XWIFT | ~90.62M XWIFT |
| Year 8.12 | **0.9 XWIFT** | **2,592 XWIFT** | **946,728 XWIFT** | **~108.79M XWIFT** |
| Year 10+ | **0.9 XWIFT** | **2,592 XWIFT** | **946,728 XWIFT** | Growing infinitely |

### Why Tail Emission?
- **Long-term Security:** Perpetual miner rewards ensure network security even as transaction fees fluctuate
- **Lost Coin Protection:** Compensates for coins lost to forgotten keys or accidents
- **Stable Inflation:** ~0.87% annual inflation declining perpetually, preventing deflation spiral

### Development Fund
- **Amount:** 2% of block rewards
- **Duration:** First year only (~1.11 million XWIFT)
- **Purpose:** Protocol development, security audits, and ecosystem growth
- **Transparency:** All transactions visible on blockchain

## Documentation

- **[README_XWIFT.md](README_XWIFT.md)** - Xwift-specific documentation and deployment guide
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Comprehensive production deployment
- **[LOCAL_TESTING_GUIDE.md](LOCAL_TESTING_GUIDE.md)** - Development and testing setup
- **[COMPLETE_CUSTOMIZATION_VERIFICATION.md](COMPLETE_CUSTOMIZATION_VERIFICATION.md)** - Fork verification

## Building from Source

### Dependencies

The following tools and libraries are required to build:

| Dependency   | Min. Version  | Purpose          |
| ------------ | ------------- | ---------------- |
| GCC          | 7             | Compiler         |
| CMake        | 3.10          | Build system     |
| Boost        | 1.66          | C++ libraries    |
| OpenSSL      | any           | Cryptography     |
| libzmq       | 4.2.0         | ZeroMQ library   |
| libunbound   | 1.4.16        | DNS resolver     |
| libsodium    | any           | Cryptography     |

### Build Instructions

```bash
# Clone with submodules
git clone --recursive https://github.com/diamondsteel259/Xwift.git
cd Xwift

# Build
make release

# Optional: Build with multiple cores
make release -j$(nproc)

# Binaries will be in build/release/bin/
```

## Running Xwift

### Start Daemon

```bash
# Run in foreground
./build/release/bin/xwiftd

# Run in background
./build/release/bin/xwiftd --detach --log-file xwiftd.log

# Testnet
./build/release/bin/xwiftd --testnet
```

### Using the Wallet

```bash
# Create new wallet
./build/release/bin/xwift-wallet-cli --generate-wallet my-wallet

# Restore from seed
./build/release/bin/xwift-wallet-cli --restore-deterministic-wallet

# Connect to remote node
./build/release/bin/xwift-wallet-cli --daemon-address node.example.com:19081
```

## Docker Deployment

```bash
# Build and run using Docker Compose
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f
```

## Security Considerations

- **Network Isolation**: Xwift runs on separate ports and network IDs from Monero
- **Test Before Production**: Always test on testnet before using mainnet
- **Backup Your Wallet**: Store your 25-word seed phrase securely
- **Use Strong Passwords**: Encrypt wallet files with strong passphrases
- **Run Trusted Nodes**: When possible, run your own node rather than relying on remote nodes

## Contributing

Xwift welcomes contributions! If you have bug fixes, improvements, or new features:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request to the `master` branch

For significant changes, please open an issue first to discuss your proposed changes.

## License

Xwift is free software released under the BSD 3-Clause License. See [LICENSE](LICENSE) for details.

## Acknowledgments

Xwift is built upon the excellent work of:
- The Monero Project and its contributors
- The CryptoNote developers
- The broader cryptocurrency open-source community

## Support & Community

- **Issues**: https://github.com/diamondsteel259/Xwift/issues
- **Pull Requests**: https://github.com/diamondsteel259/Xwift/pulls

## Disclaimer

Xwift is experimental software. While based on battle-tested Monero technology, the custom network parameters and modifications mean you should:

- Test thoroughly before production use
- Never invest more than you can afford to lose
- Understand the risks of cryptocurrency
- Keep your software updated
- Maintain secure backups

---

**Xwift: Privacy-focused cryptocurrency with optimized performance** 🚀
