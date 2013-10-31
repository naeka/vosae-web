eu() {
  export AWS_ACCESS_KEY_ID=$EU_AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$EU_AWS_SECRET_ACCESS_KEY
}

if [[ $TRAVIS_PULL_REQUEST != 'false' ]]; then
  echo "This is a pull request. No before script will be done."
elif [[ $TRAVIS_BRANCH == 'master' || $TRAVIS_BRANCH == 'develop' ]]; then
  eu
else
  echo "Nothing to do..."
fi