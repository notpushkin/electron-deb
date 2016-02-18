tmp=$(mktemp -d --tmpdir electron-deb.XXXXXX)

mkdir -p cache; pushd cache
  if [[ $# == 0 || $1 == "latest" ]]; then
    version=$(curl https://api.github.com/repos/atom/electron/releases/latest | jq .tag_name | tr -cd [:digit:].)
  else
    version="$1"
  fi

  if [[ ! -f "electron-v${version}-linux-x64.zip" ]]; then
    wget "https://github.com/atom/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip"
  fi

  mkdir -p "$tmp/opt/electron"
  unzip "electron-v${version}-linux-x64.zip" -d "$tmp/opt/electron"
popd

mkdir -p dist
fpm -s dir -t ${2-deb} \
    -n "electron" \
    -v "${version}" \
    -a "amd64" \
    -m "Alexander Pushkov <ale@songbee.net>" \
    --license "MIT" \
    --description "$(cat DESCRIPTION)" \
    --url "https://github.com/iamale/electron-deb" \
    --after-install "scripts/after_install.sh" \
    -p "dist/electron_${version}_amd64.deb" \
    -C $tmp .

aptly repo add electron-deb "dist/electron_${version}_amd64.deb"
