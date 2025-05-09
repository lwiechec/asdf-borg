#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/borgbackup/borg"

fail() {
  echo -e "asdf-borg: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if borg is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' |
    grep -v 'dev[0-9]*' |
    cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version="$1"
  local filename="$2"

  case "$(uname -s)" in
    Linux*) platform=linux ;;
    Darwin*) platform=macos ;;
  esac

  case "$(uname -m)" in
    x86_64) arch=64 ;;
  esac

  echo >&2 "* Downloading borg release $version..."

  local buildver
  buildver="glibc236"

  local url
  if [ $(echo $version | grep '1\.[012]?') ]; then
      url="$GH_REPO/releases/download/$version/borg-${platform}${arch}"
  else
      if [ $platform = "linux" ]; then
	  url="$GH_REPO/releases/download/$version/borg-${platform}-${buildver}"
      fi
  fi

  curl "${curl_opts[@]}" -o "$filename" -C - "$url" >&/dev/null && return

  fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-borg supports release installs only"
  fi

  local release_file="$install_path/bin/borg"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"

    local tool_cmd
    tool_cmd="borg"
    chmod +x "$install_path/bin/$tool_cmd"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "borg $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing borg $version."
  )
}
