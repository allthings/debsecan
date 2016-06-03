# debsecan - Debian Security Analyzer

## Usage
Expose the `dpkg` directory of the target docker image, e.g. `debian:jessie`:

```sh
docker run --entrypoint true -v /var/lib/dpkg --name debsecan_target \
  debian:jessie
```

Run `debsecan` with the `dpkg` volume of the target docker image:

```sh
docker run --rm --volumes-from=debsecan_target qipp/debsecan \
  --format detail
```

Alternatively, show only CVEs with an available fix in the Debian repositories:

```sh
docker run --rm --volumes-from=debsecan_target qipp/debsecan \
  --suite jessie --only-fixed
```

Remove the target docker image:

```sh
docker rm -vf debsecan_target
```

## License
Released under the [MIT license](http://www.opensource.org/licenses/MIT).
