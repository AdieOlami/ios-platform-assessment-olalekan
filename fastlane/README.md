fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios deps

```sh
[bundle exec] fastlane ios deps
```

Updates dependencies for iOS and watchOS

### ios build_for_testing

```sh
[bundle exec] fastlane ios build_for_testing
```

Build the app for testing

### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Sync certificates and provisioning profiles for App Store distribution

### ios create_build

```sh
[bundle exec] fastlane ios create_build
```

Build and sign IPA for App Store distribution

### ios submit_to_app_store

```sh
[bundle exec] fastlane ios submit_to_app_store
```

Upload IPA to App Store Connect and submit for review

### ios build_testflight

```sh
[bundle exec] fastlane ios build_testflight
```

Upload build to TestFlight for beta testing

### ios unit_test

```sh
[bundle exec] fastlane ios unit_test
```

A custom fastlane lane to run the unit tests

### ios ui_test

```sh
[bundle exec] fastlane ios ui_test
```

A custom fastlane lane to run the UI tests

### ios test_all

```sh
[bundle exec] fastlane ios test_all
```

Run all tests (unit and UI)

### ios clean_all

```sh
[bundle exec] fastlane ios clean_all
```

Clean build artifacts and test outputs

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Run SwiftLint

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
