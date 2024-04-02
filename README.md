# Coding Challenge 55: xxd

## Background

Challenge #55 is for an [xxd](https://codingchallenges.substack.com/p/coding-challenge-55-xxd) clone. 

### Stretch Challenge

Complete the challenge using [Swift](https://www.swift.org/) as a command line app for macOS.
- use XCode tooling and standard Swift based libraries as much as possible, e.g. logging, testing frameworks etc.
- I've used Swift on projects before for building Apps but it's been a while. Hopefully this will refresh the Swift basics for me.

- Things that I see as challenges in this effort:
    - Stucts vs Classes
    - Swift I/O
    - Command Line argument processsing
    - Getting lost in how much Swift has evolved since I last used it

- Although we're using Swift this should be runnable under Linux with the proper compilier/libraries

## Toolchain

- XCode 15.3

## Step 0

- Set up development enviornment
    - Create XCode command line progject
    - init git repo locally and on Github 
- Run "hello world"
- run command line tool from terminal
    - `Product` -> `Show Build Folder in Finder`

- figure out [command line](https://apple.github.io/swift-argument-parser/documentation/argumentparser/gettingstarted/) processing in Swift
    - The Swift [`ArgumentParser`](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) package looks like the way to go
    - Add by `File` -> `Add Package Dependencies...`
        - Generates a `Package.swift` file with the approperiate entries somewhere in the project presumabally
    - Turns out that using `ArgumentParser` on a struct with other non-argument properties causes all kinds of hell with [`Decoder`](https://forums.swift.org/t/how-to-exclude-members-from-parsing/34325). Not something I enjoyed tracking down right out of the gate
    
- figure out testing framework in Swift
    - [XCTest](https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods) is the built in one for XCode but there are other frameworks out there
    - This was WAY HARDER than I was expecting. I could not figure out how to get it to include the `struct` I wanted to test. Turns out I had to add the file with the `struct` under test to the test "target".
    
- figure out logging in Swift
    - [Logger](https://developer.apple.com/documentation/os/logger) struct is evidenlty the way to go
    - This was where I ran into problems with the commnad line processing
     
- Rewrite "hello world" to use commandline, logging and testing
    - [`@main`](https://reintech.io/blog/mastering-swifts-main-attribute-guide) explained
        - Can not use `@main` [in a file called `main`](https://stackoverflow.com/questions/73431031/swift-cli-app-main-attribute-cannot-be-used-in-a-module-that-contains-top-leve).. stupid
    - as I mentioned earlier, getting through this took way longer. Really fighting documentation issues. Phind helped but still lots of struggles. At least I'm ready to move on to step 1...
    
## Step 1

Basically dump some input file out as "hex" like `xxd` does

- need a command line argument to read the file
- format the output in 3 sections:
    - offset from beginning of the file, in hex - 8 bytes long
    - the hex output - 16 bytes long in a default of 4 "octets"
    - the ascii output - also 16 bytes but in char form. anything outside of printable chars is a `.`



