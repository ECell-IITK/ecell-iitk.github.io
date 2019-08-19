#!/bin/bash
# Common Variables ------------------------------------------>
# Target Variables
TARGET_REPO_SLUG=ECell-IITK/ecell-production
TARGET_BRANCH=master
TARGET_BASE_DIRECTORY="."
BUILD_TAG=ECELLMASTER
# Directories not to clean up
KEEP_DIRECTORIES=(esummit tedx sip ca CNAME)
#------------------------------------------------------------>

CURRENT_REPO_PATH=$PWD
echo $PWD
# rm -rf .git .gitignore
pushd $HOME
git clone --branch=$TARGET_BRANCH https://$GITHUB_TOKEN@github.com/$TARGET_REPO_SLUG target
cd target
TARGET_GIT_HEAD=$PWD
eval mkdir -p $TARGET_BASE_DIRECTORY
eval cd $TARGET_BASE_DIRECTORY

# Makes command that will be executed (to clean old files)
COMMAND="find . -maxdepth 1 ! ( -name . -o -name .. -o -name .git -o -name .gitignore"
for DIRECTORY in "${KEEP_DIRECTORIES[@]}"; do
    COMMAND+=" -o -name "$DIRECTORY
done
COMMAND+=" )"
FINAL_COMMAND=$COMMAND" -exec rm -rf {} ;"
echo "Executing command: "$FINAL_COMMAND
echo "Deleting files:"
$COMMAND
$FINAL_COMMAND

# v1 (on Esummit repo it caused problems)
# cp -rv $CURRENT_REPO_PATH/* .
rsync -av $CURRENT_REPO_PATH/* . --exclude .git
ls -alh

# At this time everything is updated
eval cd $TARGET_GIT_HEAD
git add -A
git config user.name "Bot-Ecell"
git config user.email "ecelliitkweb@gmail.com"
git commit -m "Bot Build ID: "$BUILD_TAG$TRAVIS_BUILD_NUMBER
git push origin $TARGET_BRANCH
popd
