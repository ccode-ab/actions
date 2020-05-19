#!/bin/bash

echo "From $FTP_DESTINATION to $FTP_SOURCE"

/opt/duck/duck --upload "ftps://$FTP_USERNAME@$FTP_HOST$FTP_DESTINATION" $(pwd)/$FTP_SOURCE/* --password "$FTP_PASSWORD" --nokeychain --existing overwrite
