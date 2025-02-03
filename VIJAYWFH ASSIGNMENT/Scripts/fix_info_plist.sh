#!/bin/sh

# Remove duplicate Info.plist files
find "${BUILT_PRODUCTS_DIR}" -name 'Info.plist' -not -path "*/VIJAYWFH ASSIGNMENT.app/*" -delete

# Ensure correct Info.plist is used
if [ -f "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}" ]; then
    cp "${SRCROOT}/VIJAYWFH ASSIGNMENT/Info.plist" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
fi 