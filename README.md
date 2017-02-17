# debsecan - Debian Security Analyzer

## Usage

```sh
./debsecan.sh docker/image:tag [debsecan_args...]
```

See the [debsecan homepage](http://www.enyo.de/fw/software/debsecan/) for
available arguments.

## Examples
Display detailed information about open CVEs in the `debian:jessie` image:

```sh
./debsecan.sh debian:jessie --format detail
```

Only list CVEs for packages that have been fixed in the Debian repositories:

```sh
./debsecan.sh debian:jessie --suite jessie --only-fixed
```

## License
Released under the [MIT license](https://opensource.org/licenses/MIT).
