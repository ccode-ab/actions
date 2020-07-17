#!/bin/bash

# Copy files into place
mkdir -p "$GOPATH/src/$PACKAGES_PREFIX/"
for PACKAGE in $(echo "$PACKAGES" | sed "s/,/ /g"); do
    echo "Copying $PACKAGE..."; 
    cp -R "$PACKAGE" "$GOPATH/src/$PACKAGES_PREFIX/$PACKAGE";
done
cp main.go "$GOPATH/src/$PACKAGES_PREFIX/main.go" || true

# Run tests and copy coverage
mkdir coverprofiles/
PACKAGE_TOTALS=""
for PACKAGE in $(echo "$TEST_PACKAGES" | sed "s/,/ /g"); do
    echo "Testing $PACKAGES_PREFIX/$PACKAGE..."; 
    go test -timeout 300s -parallel 1 -v "-coverprofile=coverprofiles/${PACKAGE/\//-}" "$PACKAGES_PREFIX/$PACKAGE" | tee "$PACKAGE.log";
    PACKAGE_TOTAL=$(cat "$PACKAGE.log" | grep coverage | grep -o '[^ ]*%');
    PACKAGE_TOTAL="${PACKAGE_TOTAL//[!0-9.]/}";
    PACKAGE_TOTALS=$(printf "$PACKAGE_TOTALS\n$PACKAGE_TOTAL");
done

# Print coverage
echo "$PACKAGE_TOTALS" | tail -n +2 > totals
AVG=$(awk '{ total += $0; count++ } END { print total/count }' totals)
"echo 'Code Coverage: '$AVG'%'"
