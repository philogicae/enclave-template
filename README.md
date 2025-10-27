# enclave-template

fdevc runnable project for [Enclave](https://github.com/gnosisguild/enclave) powered by [fast_dev_container](https://github.com/philogicae/fast_dev_container).

> Docs: [Enclave Hello World](https://docs.enclave.gg/hello-world-tutorial)

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/philogicae/enclave-template/main/install_and_run | bash
```

**Requirements:** Docker (or Podman/compatible), Python 3, and Git.

> If not already present, it will automatically install [fast_dev_container](https://github.com/philogicae/fast_dev_container).

## Structure

- **`install_and_run`** - Installation script that ensures `fdevc` is available, clones this repository, and runs `launch.sh`.
- **`launch.sh`** - Helper script to launch a container using `fdevc` with predefined settings. Edit the configuration variables at the top to customize ports, image, persistence, etc.
- **`runnable.sh`** - The main script that runs inside the container (complete Enclave setup).