# enclave-template

One-liner to install & run a `fdevc runnable project` for [Enclave](https://github.com/gnosisguild/enclave) powered by [fdevc](https://github.com/philogicae/fast_dev_container)

[![Curl](https://img.shields.io/badge/curl-required-orange)](https://curl.se/)
[![Git](https://img.shields.io/badge/git-required-orange)](https://git-scm.com/)
[![Docker](https://img.shields.io/badge/docker-required-orange)](https://www.docker.com/get-started/)
[![Python](https://img.shields.io/badge/python-3.10%2B-blue)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/philogicae/enclave-template)

> Docs: [Enclave Hello World](https://docs.enclave.gg/hello-world-tutorial)

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/philogicae/enclave-template/main/install_and_run | bash
```

> If not already present, it will automatically install [fdevc](https://github.com/philogicae/fast_dev_container)

## Structure

```
enclave-template/
├── README.md
├── install_and_run        # Installation script (curl one-liner)
├── launch.sh              # Container launcher with predefined settings
└── fdevc_setup/
    └── runnable.sh        # Main script that runs inside the container
```

- **`install_and_run`** - Installation script that ensures `fdevc` is available, clones this repository, and runs `launch.sh`.
- **`launch.sh`** - Helper script to launch a container using `fdevc` with predefined settings. Edit the configuration variables at the top to customize ports, image, persistence, etc.
- **`fdevc_setup/runnable.sh`** - The main script that runs inside the container (complete Enclave setup). The `fdevc_setup` folder is mounted to `/workspace` in the container.

## Usage

> Required: You runned quick install script or ./launch.sh directly

Add Anvil (Hardhat Local Network) to your browser wallet extension (e.g. [MetaMask](https://metamask.io/), [Rabby](https://rabby.io/), etc):

```bash
Network Name: Anvil (or Localhost)
RPC URL: http://127.0.0.1:8545 (or any other forwarded port you configured)
Chain ID: 31337
Currency Symbol: ETH 
Block Explorer URL: (Optional) Leave blank 
```

For testing, add any Hardhat pre-funded account to your browser wallet extension:

```bash
Account #0: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 (10000 ETH)
Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

Account #1: 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 (10000 ETH)
Private Key: 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

Account #2: 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc (10000 ETH)
Private Key: 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
```

Try out Enclave template at [http://localhost:3000](http://localhost:3000) (or any other forwarded port you configured)