# enclave-template

One-liner to install & run a `fdevc runnable project` for [Enclave](https://github.com/gnosisguild/enclave) powered by [fdevc](https://github.com/philogicae/fast_dev_container)

[![Curl](https://img.shields.io/badge/curl-required-orange)](https://curl.se/)
[![Git](https://img.shields.io/badge/git-required-orange)](https://git-scm.com/)
[![Docker](https://img.shields.io/badge/docker-required-orange)](https://www.docker.com/get-started/)
[![Python](https://img.shields.io/badge/python-3.10%2B-blue)](https://www.python.org/downloads/)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/philogicae/enclave-template)

> Docs: [Enclave Hello World](https://docs.enclave.gg/hello-world-tutorial)

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/philogicae/enclave-template/main/install_and_run | bash
```

> If not already present, it will automatically install [fdevc](https://github.com/philogicae/fast_dev_container)

## Structure

- **`install_and_run`** - Installation script that ensures `fdevc` is available, clones this repository, and runs `launch.sh`.
- **`launch.sh`** - Helper script to launch a container using `fdevc` with predefined settings. Edit the configuration variables at the top to customize ports, image, persistence, etc.
- **`runnable.sh`** - The main script that runs inside the container (complete Enclave setup).