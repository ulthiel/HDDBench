# SimpleBench

Very simple bash scripts for Linux and MacOS to test computer performance. Nothing won't be super accurate but should give a basic idea about the performance. Use at your own risk.

## HDD

The script ```hdd.sh``` determines HDD write/read speed. It cleans up memory to avoid caching. 

You'll either have to run it as root or be able to ```sudo```. You'll need to have 2GB of both HDD and RAM available.

Simply run ```sh hdd.sh```. You'll need to enter a path for the test file to be written to. This allows you to benchmark different devices without moving the script. You can also pass the path as an argument to the script.

Here's an example:

```
$ sh hdd.sh 
Path for test file (e.g. /tmp): /tmp
Getting sudo rights for cleaning memory...
Password:
Running write test...
Purging memory for read test...
Running read test...
Cleaning up...
Write speed: 77.984 MB/sec
Read speed: 53.798 MB/sec
```
