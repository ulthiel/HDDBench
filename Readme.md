# SimpleBench

Very simple bash scripts for Linux and macOS to test computer performance. Nothing won't be super accurate but should give a rough estimate. **Use at your own risk.**

## HDD

The script ```hdd.sh``` determines HDD write/read speed. You'll need to have 2GB of both HDD and RAM available (this can be changed in the option section of the script, however). As the script cleans up memory before the read test, you'll either have to run it as root or be able to ```sudo```.

Simply run ```sh hdd.sh```. You'll need to enter a path for the test file to be written to. This allows you to benchmark different devices without moving the script. You can also pass the path as an argument to the script.

Here's an example:

```
$ sh hdd.sh
Path for test file (e.g. /tmp): /tmp
Running write test...
Cleaning memory (needs sudo)...
Running read test...
Cleaning up...
-------------------------
Write speed: 1501.73 MB/s
Read speed: 2213.89 MB/s
-------------------------
```

### Results

| HDD | Write [MB/s] | Read [MB/s] |
| --- | ---- | ----- |
| Apple SSD SM0512L   | 1501.73  | 2213.89  |
| WD My Passport 25E1  | 80.76  |  83.01 |
| SanDisk Ultra Fit   | 30.19  | 153.61  |


## CPU

The script ```cpu.sh``` runs very simple integer and floating point computations using bc to determine relative CPU speed.

Here's an example:

```
$ sh cpu.sh
Running integer test...
Running floating point test...
-------------------------
Integer: 59.30s
Floating point: 58.19s
```

### Results

| CPU | Integer [s] | Float [s] |
| --- | ----------- | --------- |
| Intel(R) Core(TM) i5-8600 CPU @ 3.10GHz | 59.30 | 58.19 |
| Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz | 68.46 | 44.69 |
| Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz | 76.31  | 78.28 |
| Intel(R) Xeon(R) CPU E5-2620 @ 2.00GHz  | 103.65 | 69.64 |
