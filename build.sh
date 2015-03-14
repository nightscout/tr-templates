#! /bin/bash -eu

OUT=${OUT-'_site/'}
rm -Rf $OUT
# mkdir $OUT
export GIT_EMAIL=$GIT_EMAIL
export GIT_USER=$GIT_USER
# echo $FOO $BAR
# GIT_REMOTE=$(git config remote.origin.url)
export NEW_REMOTE="https://${GH_TOKEN}@github.com/${GH_REPO}.git"
( git clone -q -b gh-pages "$NEW_REMOTE" $OUT ) 2>&1 > /dev/null
ls $OUT
(
  cd $OUT;
  git rm -r -q ./*
  ls

)
ls -alh
msg=""
if [[ -n $WERCKER_GIT_COMMIT && -d build ]] ; then
  cp -rv build/* $OUT
  msg="build from $(echo $WERCKER_GIT_COMMIT | cut -c 1-8)"

else
  msg="build from $(git rev-parse HEAD)"
fi
# bundle install
# make gh-build
(
  cd $OUT;
  # cp ../CNAME CNAME
  touch .nojekyll
  git config --local user.email "$GIT_EMAIL"
  git config --local user.name "$GIT_USER"
  git add .
  # git add .travis.yml
  git add .nojekyll
  git status
  git commit -avm "$msg"
  # gh-pages uses master branch on user/org repos
  ( git push -q origin gh-pages
  ) 2>&1 > /dev/null

)
