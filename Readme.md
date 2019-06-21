# SimpleBench

Very simple bash scripts for Linux and macOS to test computer performance. Nothing won't be super accurate but should give a basic idea about the performance. Use at your own risk.

For macOS you first need to install the GNU coreurtils via ```brew install coreutils``` (you have to install [homebrew](https://brew.sh) to do this).

## HDD

The script ```hdd.sh``` determines HDD write/read speed. You'll need to have 2GB of both HDD and RAM available (this can be changed in the option section of the script, however). As it cleans up memory before the read test, you'll either have to run it as root or be able to ```sudo```.

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
