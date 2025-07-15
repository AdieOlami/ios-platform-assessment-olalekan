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

### ios unit_tests

```sh
[bundle exec] fastlane ios unit_tests
```

A custom fastlane lane to run the unit tests

### ios ui_tests

```sh
[bundle exec] fastlane ios ui_tests
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

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
