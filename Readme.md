# SimpleBench

Very simple bash scripts for Linux and macOS to test computer performance. Nothing won't be super accurate but should give a rough estimate. **Use at your own risk.**

I just wanted to use GNU coretools and no extra software. As the macOS versions of these tools sometimes behave differently, you first need to install the GNU coreutils via ```brew install coreutils``` if you use macOS; and for this, you first have to install [homebrew](https://brew.sh).

## HDD

The script ```hdd.sh``` determines HDD write/read speed. You'll need to have 2GB of both HDD and RAM available (this can be changed in the option section of the script, however). As the script cleans up memory before the read test, you'll either have to run it as root or be able to ```sudo```.

Simply run ```sh hdd.sh```. You'll need to enter a path for the test file to be written to. This allows you to benchmark different devices without moving the script. You can also pass the path as an argument to the script.

Here's an example:

```
$ sh hdd.sh
Path for test file (e.g. /tmp): /tmp
Running write test...
Cleaning memory (needs sudo)...
Password:
Running read test...
Cleaning up...
HDD write speed: 47.9MB/s
HDD read speed: 50.6MB/s
```
