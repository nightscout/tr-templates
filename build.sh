#! /bin/bash -eu

OUT=_site/
rm -Rf $OUT
# mkdir $OUT
export GIT_EMAIL=$GIT_EMAIL
export GIT_NAME=$GIT_NAME
echo $FOO $BAR
GIT_REMOTE=$(git config remote.origin.url)
export NEW_REMOTE="https://${GH_TOKEN}@github.com/${GH_REPO}.git"
( git clone -q -b gh-pages "$NEW_REMOTE" $OUT ) 2>&1 > /dev/null
ls $OUT
(
  cd $OUT;
  git rm -r -q ./*
  ls

)
make build
msg="build from $(git rev-parse HEAD)"
(
  cd $OUT;
  # cp ../CNAME CNAME
  touch .nojekyll
  git config --local user.email "$GIT_EMAIL"
  git config --local user.name "$GIT_NAME"
  git add .
  git add .travis.yml
  git add .nojekyll
  git status
  git commit -avm "$msg"
  # gh-pages uses master branch on user/org repos
  ( git push -q origin master:gh-pages
  ) 2>&1 > /dev/null

)