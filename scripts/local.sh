#!/bin/bash

# Notification Service Local Development Script

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="notification_service"
DEFAULT_PORT=8083

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Maven is installed
check_maven() {
    if ! command -v ./mvnw &> /dev/null; then
        print_error "Maven wrapper not found"
        exit 1
    fi
    print_success "Maven wrapper is available"
}

# Function to build the application
build() {
    print_status "Building $APP_NAME..."
    ./mvnw clean package -DskipTests
    print_success "Build completed successfully!"
}

# Function to run the application
run() {
    print_status "Starting $APP_NAME locally..."
    export SPRING_PROFILE=local
    ./mvnw spring-boot:run
}

# Function to run tests
test() {
    print_status "Running tests for $APP_NAME..."
    ./mvnw test
    print_success "Tests completed!"
}

# Function to show help
show_help() {
    echo "Notification Service Local Development Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build     Build the application"
    echo "  run       Run the application locally"
    echo "  test      Run tests"
    echo "  help      Show this help message"
}

# Main script logic
main() {
    # Change to project root directory
    cd "$(dirname "$0")/.."
    
    # Check prerequisites
    check_maven
    
    case "${1:-help}" in
        "build")
            build
            ;;
        "run")
            run
            ;;
        "test")
            test
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
