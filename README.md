# Electron for Linux packages

```sh
echo "deb https://dl.bintray.com/ale/electron-deb any main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install electron electron-example
electron-example
```

For usage, see [electron-example][example/].
