#!/bin/sh
set -ex

PLIST=$FCI_BUILD_DIR/wand/Info.plist
PLIST_BUDDY=/usr/libexec/PlistBuddy

# Delete the existing Assets.xcassets from the project and copy the ones we have cloned from the assets repo 
rm -rf wand/Assets.xcassets
cp -R assets/resources/Assets.xcassets wand/Assets.xcassets

# Delete Credentials.plist from project if present and use verion from repo
rm -rf wand/Credentials.plist
cp -R assets/resources/Credentials.plist wand/Credentials.plist

# Set the bundle id $BUNDLE_ID which is passed as environment variable in API request to trigger the build
$PLIST_BUDDY -c "Set :CFBundleIdentifier $BUNDLE_ID" $PLIST

# Set CFBundleDisplayName using $BUNDLE_DISPLAY_NAME which is passed as environment variable in API request to trigger the build
$PLIST_BUDDY -c "Set :CFBundleDisplayName $BUNDLE_DISPLAY_NAME" $PLIST

# Set CFBundleShortVersionString using $BUNDLE_VERSION which is passed as environment variable in API request to trigger the build
$PLIST_BUDDY -c "Set :CFBundleShortVersionString $BUNDLE_VERSION" $PLIST

