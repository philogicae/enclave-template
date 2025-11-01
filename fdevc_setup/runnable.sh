#!/usr/bin/env bash
set -euo pipefail

# Colors and styling (consistent with install_and_run)
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[96m"
GREEN="\033[92m"
RED="\033[91m"
YELLOW="\033[93m"

# Icons
ICON_ARROW="→"
ICON_CHECK="✓"
ICON_CROSS="✗"

# Logging functions
log_step() {
	echo -e "${BOLD}${CYAN}${ICON_ARROW} $1${RESET}"
}

log_success() {
	echo -e "${BOLD}${GREEN}${ICON_CHECK} $1${RESET}"
}

log_error() {
	echo -e "${BOLD}${RED}${ICON_CROSS} $1${RESET}" >&2
}

log_warning() {
	echo -e "${BOLD}${YELLOW}⚠ $1${RESET}"
}

log_detail() {
	echo -e "  ${DIM}$1${RESET}"
}

# Configuration variables
LOCAL_BIN="${HOME}/.local/bin"
RISC0_BIN="${HOME}/.risc0/bin"
RISC0_INSTALL_URL="https://risczero.com/install"
ENCLAVE_INSTALL_URL="https://raw.githubusercontent.com/gnosisguild/enclave/main/install"
RETRY_COUNT=3
RETRY_DELAY=5

# Utility functions
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

retry() {
	local attempts=$1
	shift
	local count=0
	until "$@"; do
		exit_code=$?
		count=$((count + 1))
		if [ $count -lt "$attempts" ]; then
			log_warning "Command failed (attempt $count/$attempts). Retrying in ${RETRY_DELAY}s..."
			sleep $RETRY_DELAY
		else
			log_error "Command failed after $attempts attempts"
			return $exit_code
		fi
	done
}

setup_path() {
	# Add LOCAL_BIN to PATH if not already present
	if ! grep -q "$LOCAL_BIN" ~/.bashrc 2>/dev/null; then
		log_detail "Adding $LOCAL_BIN to PATH in ~/.bashrc"
		echo "export PATH=\"$LOCAL_BIN:\$PATH\"" >>~/.bashrc
	fi

	# Export PATH for current session
	export PATH="$LOCAL_BIN:$PATH"

	# Add RISC0_BIN to PATH if exists
	if [ -d "$RISC0_BIN" ]; then
		export PATH="$RISC0_BIN:$PATH"
	fi
}

install_rzup() {
	if command_exists rzup; then
		log_success "rzup already installed"
		return 0
	fi

	log_step "Installing rzup..."
	if retry $RETRY_COUNT curl -fsSL "$RISC0_INSTALL_URL" | bash; then
		# Re-export PATH after installation
		if [ -d "$RISC0_BIN" ]; then
			export PATH="$RISC0_BIN:$PATH"
		fi

		if command_exists rzup; then
			log_success "rzup installed successfully"
		else
			log_error "rzup installation failed"
			exit 1
		fi
	else
		log_error "Failed to download rzup installer"
		exit 1
	fi
}

install_risczero_toolchain() {
	if command_exists cargo-risczero; then
		log_success "RISC Zero toolchain already installed"
		return 0
	fi

	log_step "Installing RISC Zero toolchain..."
	if retry $RETRY_COUNT rzup install cargo-risczero; then
		log_success "RISC Zero toolchain installed successfully"
	else
		log_error "Failed to install RISC Zero toolchain"
		exit 1
	fi
}

install_enclave() {
	if command_exists enclave; then
		log_success "Enclave CLI already installed"
		return 0
	fi

	# Install enclaveup if not present
	if ! command_exists enclaveup; then
		log_step "Installing enclaveup..."
		if retry $RETRY_COUNT curl -fsSL "$ENCLAVE_INSTALL_URL" | bash; then
			export PATH="$LOCAL_BIN:$PATH"

			# Try alternative paths if needed
			if ! command_exists enclaveup; then
				log_detail "Searching for enclaveup in alternative paths..."
				for path in "$HOME/.local/bin" "/root/.local/bin" "$HOME/.cargo/bin"; do
					if [ -f "$path/enclaveup" ]; then
						log_detail "Found enclaveup at $path"
						export PATH="$path:$PATH"
						break
					fi
				done
			fi

			if command_exists enclaveup; then
				log_success "enclaveup installed successfully"
			else
				log_error "enclaveup installation failed"
				exit 1
			fi
		else
			log_error "Failed to download enclaveup installer"
			exit 1
		fi
	fi

	# Install Enclave CLI
	log_step "Installing Enclave CLI..."
	if retry $RETRY_COUNT enclaveup install; then
		export PATH="$LOCAL_BIN:$PATH"
		if command_exists enclave; then
			log_success "Enclave CLI installed successfully"
		else
			log_error "Enclave CLI installation failed"
			exit 1
		fi
	else
		log_error "Failed to install Enclave CLI"
		exit 1
	fi
}

initialize_project() {
	if [ -f "template/package.json" ]; then
		log_success "Enclave template project already initialized"
		return 0
	fi

	log_step "Initializing Enclave template project..."
	if retry $RETRY_COUNT enclave init tmp; then
		log_step "Copying files to template directory..."
		rsync -a --ignore-existing tmp/ template/
		rm -rf tmp
		chmod -R 777 template
		log_success "Enclave template project initialized"
	else
		log_error "Failed to initialize Enclave template project"
		exit 1
	fi
}

compile_and_start() {
	log_step "Changing to template directory..."
	cd template

	log_step "Compiling Enclave program..."
	if retry $RETRY_COUNT enclave program compile; then
		log_success "Enclave program compiled successfully"
	else
		log_error "Failed to compile Enclave program"
		exit 1
	fi

	log_step "Ensuring pnpm dependencies are installed..."
	CI=true pnpm install --frozen-lockfile -s

	log_step "Starting development environment..."
	pnpm dev:all
}

# Main execution
main() {
	log_step "Setting up Enclave development environment..."

	# Setup PATH
	setup_path

	# Install dependencies
	install_rzup
	install_risczero_toolchain
	install_enclave

	# Initialize and start project
	initialize_project
	compile_and_start
}

# Run main function
main "$@"
