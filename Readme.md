# SimpleBench

Very simple bash scripts for Linux and macOS to test computer performance by just using GNU Core Utilities. Nothing won't be super accurate but should give a rough estimate. For macOS you will have to install the GNU coreutils via ```brew install coreutils```; you possibly first have to install [Homebrew](https://brew.sh) to do this.

**Use at your own risk.**


## CPU

The script ```cpu.sh``` determines relative CPU speed by running various tasks.

Here's an example:

```
$ sh cpu.sh
Running Factorization test...
Running SHA256 test...
Running Bzip test...
-------------------------
Factorization: 47.45s
SHA256: 45.75s
Bzip2: 47.40s
```

### Some results

| CPU | Factorization [s] | SHA256 [s] | Bzip2 [s] |
| --- | ----------------- | ---------- | --------- |
| [Intel(R) Core(TM) i5-8600 CPU @ 3.10GHz](https://ark.intel.com/content/www/us/en/ark/products/129937/intel-core-i5-8600-processor-9m-cache-up-to-4-30-ghz.html) | 47.45 | 45.75 | 47.40 |
| [Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz](https://ark.intel.com/content/www/us/en/ark/products/65523/intel-core-i7-3770k-processor-8m-cache-up-to-3-90-ghz.html) | 56.73 | 52.93 | 62.75 |
| [Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz](https://ark.intel.com/content/www/us/en/ark/products/95441/intel-core-i7-7y75-processor-4m-cache-up-to-3-60-ghz.html) | 56.78 | 61.96 | 63.73 |
| [Intel(R) Xeon(R) CPU E5-2697A v4 @ 2.60GHz](https://ark.intel.com/content/www/us/en/ark/products/91768/intel-xeon-processor-e5-2697a-v4-40m-cache-2-60-ghz.html)  | 60.63  | 56.18 | 77.02 |
| [Intel(R) Core(TM) i3-2330M CPU @ 2.20GHz](https://ark.intel.com/content/www/us/en/ark/products/53434/intel-core-i3-2330m-processor-3m-cache-2-20-ghz.html) | 84.10  | 105.51  | 106.38  |
| [Intel(R) Xeon(R) CPU E5-2620 @ 2.00GHz](https://ark.intel.com/content/www/us/en/ark/products/64594/intel-xeon-processor-e5-2620-15m-cache-2-00-ghz-7-20-gt-s-intel-qpi.html) | 88.47 | 104.90 | 103.85 |



## HDD

The script ```hdd.sh``` determines HDD write/read speed. You'll need to have 2GB of both HDD and RAM available (this can be changed in the option section of the script, however). As the script cleans up memory before the read test, you'll either have to run it as root or be able to ```sudo```.

Simply run ```sh hdd.sh```. You'll need to enter a path for the test file to be written to. This allows you to benchmark different devices without moving the script. You can also pass the path as an argument to the script.

Here's an example:

```
$ sh hdd.sh
Path for test file (e.g. /tmp): /tmp
Flushing caches (needs sudo)...
Running write test...
Flushing caches (needs sudo)...
Running read test...
Flushing caches (needs sudo)...
-------------------------
Write speed: 1.2GB/s
Read speed: 2.5GB/s
-------------------------
```

### Some results

| HDD | Write [MB/s] | Read [MB/s] |
| --- | ---- | ----- |
| Apple SSD SM0512L   | 1220.18  | 2502.3 |
| Apple SSD AP0256J   | 430.95 | 968.38  |

#### USB drives
| HDD | Write [MB/s] | Read [MB/s] |
| --- | ---- | ----- |
| WD My Passport 25E1  | 80.85  | 92.33 |
