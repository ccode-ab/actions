#!/bin/bash

mkdir -p "$GOPATH/src/$PACKAGES_PREFIX/"
for PACKAGE in $(echo "$PACKAGES" | sed "s/,/ /g"); do
    echo "Copying $PACKAGE..."; 
    cp -R "$PACKAGE" "$GOPATH/src/$PACKAGES_PREFIX/$PACKAGE";
done

cp main.go "$GOPATH/src/$PACKAGES_PREFIX/main.go" || true

for PACKAGE in $(echo "$PACKAGES" | sed "s/,/ /g"); do
    $GOPATH/bin/golint -set_exit_status $PACKAGE;
done
