# HDDBench

This is a simple bash script to determine HDD write/read speed under Linux/MacOS. Simply run ```sh HDDBench.sh path```, where *path* is a path for the test file to be written (e.g. "." or "/" or "/tmp" or "/dev/sda1" etc.) The path argument allows for several devices to be tested without moving the script.

Here's an example:

```
$sh HDDBench.sh /tmp
Testing /tmp
Getting sudo rights for purging memory...
Running write test...
Purging memory for read test...
Running read test...
Cleaning up...
Write speed: 466.932 MB/sec
Read speed: 516.666 MB/sec
$
```

Use at your own risk.
