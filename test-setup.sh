#!/usr/bin/env bash

# Test script for running dotfiles setup in Docker

set -e

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Colour

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Show usage
show_usage() {
    cat << EOF
Usage: ./test-setup.sh [COMMAND]

Commands:
    dry-run     Run setup in dry-run mode (default)
    minimal     Test minimal profile installation
    developer   Test developer profile installation
    full        Test full profile installation
    shell       Open interactive shell in container
    clean       Remove all test containers and images
    all         Run all test scenarios sequentially

Examples:
    ./test-setup.sh              # Run dry-run test
    ./test-setup.sh minimal      # Test minimal installation
    ./test-setup.sh shell        # Interactive debugging
    ./test-setup.sh all          # Run all tests

EOF
}

# Build the image
build_image() {
    print_header "Building Docker Image"
    docker compose build
    print_success "Image built successfully"
}

# Run a specific test
run_test() {
    local service=$1
    print_header "Running: $service"

    if docker compose run --rm "$service"; then
        print_success "$service completed successfully"
        return 0
    else
        print_error "$service failed"
        return 1
    fi
}

# Clean up
clean() {
    print_header "Cleaning Up"
    docker compose down --rmi all --volumes --remove-orphans
    print_success "Cleanup complete"
}

# Run all tests
run_all() {
    local failed=0

    build_image

    for test in dry-run minimal developer full; do
        if ! run_test "$test"; then
            ((failed++))
        fi
    done

    if [ $failed -eq 0 ]; then
        print_success "All tests passed!"
        return 0
    else
        print_error "$failed test(s) failed"
        return 1
    fi
}

# Main
main() {
    local command=${1:-dry-run}

    case "$command" in
        help|--help|-h)
            show_usage
            ;;
        clean)
            clean
            ;;
        all)
            run_all
            ;;
        dry-run|minimal|developer|full|shell)
            build_image
            run_test "$command"
            ;;
        *)
            print_error "Unknown command: $command"
            echo
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
