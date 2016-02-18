# Electron for Linux packages

Electron, while being a great way to make apps, it quite a heavy runtime. It shouldn't be bundled with each app, but rather be declared as a dependency for package managers.

This project is roughly how it should be done right™.


## Example

```sh
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 36271A1D783B07C4
echo "deb http://ale-apt.surge.sh/electron-deb/ all main" | sudo tee -a /etc/apt/sources.list.d/electron-deb.list
sudo apt-get update
sudo apt-get install electron electron-example
electron-example
```


## Building applications

See [electron-example][example/].


## Building Electron packages

To build the latest Electron, install [jq][] and [fpm][], then run `./release.sh`. If everything is OK, your package will appear in the `dist` folder (and will be added to the `electron-deb` repo in your local [Aptly][] instance, if you have one). There are optional arguments:

```
./release.sh [VERSION] [PACKAGE_TYPE]
```

where VERSION is an Electron's GitHub Release and PACKAGE_TYPE is one of package types supported by fpm.

[jq]: https://stedolan.github.io/jq/
[fpm]: https://github.com/jordansissel/fpm
[Aptly]: https://www.aptly.info/
