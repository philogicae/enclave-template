#!/usr/bin/env bash
set -e

# Determine local bin path
if [ -d "$HOME/.local/bin" ]; then
	LOCAL_BIN="$HOME/.local/bin"
else
	LOCAL_BIN="/root/.local/bin"
fi

# Add to PATH if not already present
if ! grep -q "$LOCAL_BIN" ~/.bashrc 2>/dev/null; then
	echo "export PATH=\"$LOCAL_BIN:\$PATH\"" >>~/.bashrc
fi
export PATH="$LOCAL_BIN:$PATH"

# Check if rzup is already installed
RISC0_BIN="$HOME/.risc0/bin"
if [ -d "$RISC0_BIN" ]; then
	export PATH="$RISC0_BIN:$PATH"
fi

if ! command -v rzup &>/dev/null; then
	echo "Installing rzup..."
	curl -L https://risczero.com/install | bash

	# Re-export PATH after installation
	if [ -d "$RISC0_BIN" ]; then
		export PATH="$RISC0_BIN:$PATH"
	fi

	if ! command -v rzup &>/dev/null; then
		echo "Error: rzup installation failed"
		exit 1
	fi
else
	echo "rzup already installed"
fi

# Install RISC Zero toolchain if not present
if ! command -v cargo-risczero &>/dev/null; then
	echo "Installing RISC Zero toolchain..."
	rzup install cargo-risczero
else
	echo "RISC Zero toolchain already installed"
fi

# Install Enclave if not present
if ! command -v enclave &>/dev/null; then
	# Install enclaveup
	if ! command -v enclaveup &>/dev/null; then
		curl -fsSL https://raw.githubusercontent.com/gnosisguild/enclave/main/install | bash
		export PATH="$LOCAL_BIN:$PATH"
		# Try alternative paths if needed
		if ! command -v enclaveup &>/dev/null; then
			for path in "$HOME/.local/bin" "/root/.local/bin" "$HOME/.cargo/bin"; do
				if [ -f "$path/enclaveup" ]; then
					export PATH="$path:$PATH"
					break
				fi
			done
		fi
	fi
	# Install Enclave CLI
	enclaveup install
	export PATH="$LOCAL_BIN:$PATH"
	if ! command -v enclave &>/dev/null; then
		echo "Error: enclave installation failed"
		exit 1
	fi
fi

# Initialize project if needed
if [ ! -d "template" ]; then
	enclave init template -v
fi

cd template
# Compile and start
enclave program compile
pnpm dev:all
