#!/bin/bash

set -euo pipefail

function debug() {
    echo "::debug file=${BASH_SOURCE[0]},line=${BASH_LINENO[0]}::$SRC_DIR"
}

function warning() {
    echo "::warning file=${BASH_SOURCE[0]},line=${BASH_LINENO[0]}::$SRC_DIR"
}

function error() {
    echo "::error file=${BASH_SOURCE[0]},line=${BASH_LINENO[0]}:: $SRC_DIR"
}

function add_mask() {
    echo "::add-mask::$SRC_DIR"
}

if [ -z "$GITHUB_ACTOR" ]; then
    error "GITHUB_ACTOR environment variable is not set"
    exit 1
fi

if [ -z "$GITHUB_REPOSITORY" ]; then
    error "GITHUB_REPOSITORY environment variable is not set"
    exit 1
fi

if [ -z "$GH_PERSONAL_ACCESS_TOKEN" ]; then
    error "GH_PERSONAL_ACCESS_TOKEN environment variable is not set"
    exit 1
fi

SRC_DIR=${FOLDER}
STRING=${EXCLUDE_REGEX}
WIKI_NAME=${WIKI_NAME}
add_mask "${GH_PERSONAL_ACCESS_TOKEN}"

if [ -z "${WIKI_COMMIT_MESSAGE:-}" ]; then
    debug "WIKI_COMMIT_MESSAGE not set, using default"
    WIKI_COMMIT_MESSAGE='Automatically publish wiki'
fi

GIT_REPOSITORY_URL="https://${GH_PERSONAL_ACCESS_TOKEN}@github.com/${TARGET_REPO}"

debug "Checking out wiki repository"
tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)

(
    cd "$tmp_dir" || exit 1
    git init
    git config user.name "$GITHUB_ACTOR"
    git config user.email "$GITHUB_ACTOR@users.noreply.github.com"
    git pull "$GIT_REPOSITORY_URL"
) || exit 1

debug "Enumerating contents of $SRC_DIR"


printf 'Enumerating contents of'  "$SRC_DIR"
for folder in $(find $SRC_DIR -maxdepth 1 -execdir basename '{}' ';' | sort )  ; do
  printf '%s\n' "$folder"

  for file in $(find "$SRC_DIR/$folder" -maxdepth 1 -type f -name '*.md' -execdir basename '{}' ';' | sort ); do
      if [[ "$file" == *"$STRING"* ]];then
        printf '%s\n' "$file"
      else
        printf "Copying $file"
        printf '%s\n' "$SRC_DIR/$folder/$file"
        cat "$SRC_DIR/$folder/$file" >> $WIKI_NAME
        echo '' >> $WIKI_NAME
        cp $WIKI_NAME "$tmp_dir"
      fi
  done
done

debug "Committing and pushing changes"
(
    cd "$tmp_dir" || exit 1
    git add .
    git commit -m "$WIKI_COMMIT_MESSAGE"
    git push --set-upstream "$GIT_REPOSITORY_URL" master
) || exit 1

rm -rf "$tmp_dir"
exit 0
