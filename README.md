# Bump

![Swift](https://github.com/homerooliveira/Bump/actions/workflows/build.yml/badge.svg)
[![codecov](https://codecov.io/gh/homerooliveira/Bump/branch/main/graph/badge.svg?token=33PIP7NUZO)](https://codecov.io/gh/homerooliveira/Bump)

Command line tool for versioning your Xcode projects.

## Installation

### Requirements
- Xcode 11 

### Using [Homebrew](http://brew.sh/):
```bash
brew tap homerooliveira/Bump https://github.com/homerooliveira/Bump.git
brew install bump
```

### Compiling from source:
```bash
git clone https://github.com/homerooliveira/Bump.git
cd Bump
make install
```

## Usage

First you need set  the `Bundle versions string, short` to `$(MARKETING_VERSION)` and `Bundle version` to `$(CURRENT_PROJECT_VERSION)` in every info.plist in `target` that you want to incrementable in your project.

![Info plist sample](assets/infoplist-sample.png)

Now you can use bump to increment you versions, must execute the command line tool in root directory or pass the path as argument.
```bash
bump com.test.Test1 -m build -p Tests/Resources/
```
Will show to you: 
```bash
Test1 0.0.1.1 -> 0.0.1.2
```

```mermaid
flowchart TD
    subgraph External_Packages
        XcodeProj["XcodeProj\n(xcodeproj)"]
        ArgumentParser["ArgumentParser\n(swift-argument-parser)"]
        SwiftLintPlugins["SwiftLintPlugins\n(0.55.1)"]
    end

    subgraph BumpPackage
        BumpCommandLine --> BumpCore
        BumpCommandLine --> Environment
        BumpCommandLine --> ArgumentParser

        BumpCore --> XcodeProjWrapper
        BumpCore --> SwiftExtensions

        Environment --> FileManagerWrapper
        Environment --> XcodeProjWrapper

        XcodeProjWrapper --> XcodeProj
        XcodeProjWrapper --> SwiftExtensions

        FileManagerWrapperMock --> FileManagerWrapper

        XcodeProjWrapperMock --> XcodeProjWrapper
    end

    subgraph Test_Targets
        BumpCoreTests --> BumpCore
        BumpCoreTests --> XcodeProjWrapperMock

        BumpCommandLineTests --> BumpCommandLine
        BumpCommandLineTests --> Environment
        BumpCommandLineTests --> FileManagerWrapperMock
        BumpCommandLineTests --> XcodeProjWrapperMock

        BumpCommandLineIntegrationTests --> BumpCommandLine
        BumpCommandLineIntegrationTests --> Environment

        SwiftExtensionsTests --> SwiftExtensions
    end

```