
# Bump

![Swift](https://github.com/homerooliveira/Bump/workflows/Swift/badge.svg)
[![codecov](https://codecov.io/gh/homerooliveira/Bump/branch/master/graph/badge.svg?token=33PIP7NUZO)](https://codecov.io/gh/homerooliveira/Bump)

**Bump** is a command-line tool designed to automate the versioning process in Xcode projects. It simplifies managing your project versions by automatically updating the version numbers in your `Info.plist` files, saving you from manual editing and potential errors.

## Features

- **Automated Versioning**: Automatically increments version numbers based on your preferences.
- **Customizable**: Supports different versioning strategies (e.g., major, minor, patch, build).
- **Target-Specific**: Allows versioning for specific targets within your project.
- **Integration-Friendly**: Easily integrates into your existing CI/CD pipeline.

## Installation

### Requirements

- Xcode 15.0 or later
- macOS 12.0 or later

### Install with [Homebrew](https://brew.sh/)

To install Bump using Homebrew, run the following commands:

```bash
brew tap homerooliveira/Bump https://github.com/homerooliveira/Bump.git
brew install bump
```

### Compile from Source

To build and install Bump from the source code:

```bash
git clone https://github.com/homerooliveira/Bump.git
cd Bump
make install
```

## Usage

### Initial Setup

Before using Bump, make sure your Xcode project's `Info.plist` files are configured correctly:

1. **Bundle versions string, short**: Set this to `$(MARKETING_VERSION)`.
2. **Bundle version**: Set this to `$(CURRENT_PROJECT_VERSION)`.

This setup ensures that Bump can manage your project's versioning effectively.

![Info.plist Setup](assets/infoplist-sample.png)

### Incrementing Versions

To increment your project's version, navigate to the root directory of your project and run:

```bash
bump <bundle_identifier> -m <version_type> -p <path>
```

- `<bundle_identifier>`: The bundle identifier of the target you want to update.
- `<version_type>`: The version component to increment (`major`, `minor`, `patch`, `build`).
- `<path>`: (Optional) The path to your project directory.

Example:

```bash
bump com.test.YourApp -m build -p YourProject.xcodeproj
```

This will output the new version number:

```bash
Test1 0.0.1.1 -> 0.0.1.2
```

### Advanced Options

Bump offers various options to customize the versioning process. For more details on advanced usage, run:

```bash
bump --help
```

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. Feel free to fork the repository and submit a pull request with your improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Support

If you have any questions or need help, feel free to open an issue on the [GitHub repository](https://github.com/homerooliveira/Bump) or contact the maintainer.
