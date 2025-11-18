# Default task - show available commands
default:
    @just --list

# Install dependencies and build Rust
setup:
    flutter pub get
    cd example && flutter pub get
    cd rust && cargo build

# Generate Flutter Rust Bridge bindings
generate:
    flutter_rust_bridge_codegen generate

# Build Rust library
build:
    cd rust && cargo build

# Clean all build artifacts
clean:
    flutter clean
    cd example && flutter clean
    cd rust && cargo clean

# Analyze Dart code
analyze:
    flutter analyze

# Format all code (Dart + Rust)
format:
    dart format lib test_driver example/lib example/integration_test
    cd rust && cargo fmt

# Run all checks (analyze + cargo check + clippy)
check:
    flutter analyze
    cd rust && cargo check
    cd rust && cargo clippy

# Run example app (default: linux)
run device="linux":
    cd example && flutter run -d {{device}}

# Run integration tests (default: linux)
test device="linux":
    cd example && flutter test integration_test/simple_test.dart -d {{device}}
