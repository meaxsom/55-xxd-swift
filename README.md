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

### Notes
- Opted to read the file in "chunks" of 16 x UInt8 using an extension to FileManager
- For each chunk, generate a String representation from the printable characters - as an extention to the String type
- Also for each chunk - divide into an array of arrays represeting the desired octet output "grouping". This is what we'll need in Step 2, but got that out of the way in this step. Again, used an extension this time with the Array type
- For those grouped items, generate a hex representation for outut. Leveraged an extension in Array type
- Keep track of the file offset and output that as hex

- learned a lot about using map & reduce functions in iterating over the array of bytes and array of arrays!

- Feels like there is too much struct creation going on for moving bytes around. 
    - need some way to observe memory pressure/use

- also got to be a better way to conver a byte into a char for concat into a string. I do need to do that one byte at a time for printable character reasons, but that's a lot of iterating
- Basically feeling like it works but is sub optimal - although the examples I've looked at basically do what the codes doing. Who knows

## Step 2

This step is about supporting the -e ([little-endian](https://en.wikipedia.org/wiki/Endianness)) flag and -g (group) option

- `ArgumentParser` library should come in handy here. Probably use some of the more specific syntax
- Grouping should already be done through the "chunking" call
- I'll need to come up with a strategy for converting to the `[UInt8]` chunks by swapping around bytes based on the chunk size
    - will also need to validate that the "group" is divisible by 2 if the endian option is used

### Notes
- added flags and options to the command line to handle the input
- the grouping was pretty easy since I already had the chunking figured out
- ended up writing a `toLittleEndian()` extension for `[UInt8]` and added a if statement to handle the flag
- 

## Step 3

> support the command line options to set the number of octets to be written out and the number of columns to print per line. These are the -l and -c flags [if] you want to explore the valid settings in the man entry.

- the "len" option is just how many total octets to read from the file
    - Added `OctetCounter` to help with octet bookkeeping
    - Adding padding to the hex output so incomplete lines will line up

- the "col" option is how many octets to read at once.
    - up to this point, 16's been the default column size so that needs to become flexible
    - `OctetCounter` now controls the size of the read, which is the number of "cols"

### Notes
- again, given the existing structure, this wasn't all that much of a change. Mainly rerouting some constants already in use.
- consolidating the logic in the `OctetCounter` make it pretty easy
- not sure I have the logic right between `-g`, `-e` and `-c` but the standard `xxd` seems to ignore `-g` when `-c` is in use

## Step 4

> support the -s flag which allows us to seek to a specific byte offset in the file

### Notes
- This was easy as well. Just added the `@Option` and hooked it into the logic I already anticipated for seeking to a specific offest in the file to begin reading
- It also appears that the `swift-argument-parser` got wonky in the build process. Had to readd it.


