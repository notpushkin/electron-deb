ROOT=$(mktemp -d --tmpdir electron-deb.XXXXXX)

mkdir -p cache; pushd cache
  if [[ $# == 0 || $1 == "latest" ]]; then
    version=$(curl https://api.github.com/repos/atom/electron/releases/latest | jq .tag_name | tr -cd [:digit:].)
  else
    version="$1"
  fi

  if [[ ! -f "electron-v${version}-linux-x64.zip" ]]; then
    wget "https://github.com/atom/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip"
  fi

  mkdir -p "$ROOT/opt/electron"
  unzip "electron-v${version}-linux-x64.zip" -d "$ROOT/opt/electron"
popd

cp -R platform/linux/* "$ROOT"

mkdir -p dist
fpm -s dir -t ${2-deb} \
    -n "electron" \
    -v "${version}" \
    -a "amd64" \
    -m "Alexander Pushkov <hi@ale.rocks>" \
    --license "MIT" \
    --description "$(cat DESCRIPTION)" \
    --url "https://github.com/iamale/electron-deb" \
    --after-install "scripts/after_install.sh" \
    -p "dist/electron_${version}_amd64.deb" \
    -C $ROOT .

if command -v aptly >/dev/null 2>&1; then
  echo >&2 "Aptly installed, trying to add our package to the repo..."
  aptly repo add electron-deb "dist/electron_${version}_amd64.deb"
fi
