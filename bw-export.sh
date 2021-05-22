#!/usr/bin/env bash

# fail the script as soon as an invalid password has been entered
set -e

EXPORT_NAME=bw-export-$(date "+%Y%m%d-%H%M%S")

# set BW_SESSION variable to a valid token
export BW_SESSION=$(bw unlock --raw)

# sync bitwarden to make sure we are exporting up to date data
bw sync --session $BW_SESSION

# export all entries
bw export --output ./export/bitwarden.json --format json # bw export does not seem to accept the --session parameter, so you have to enter your password here again

# per entry, check if they contain attachments and then export them
bash <(bw list items --session $BW_SESSION | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment --session $BW_SESSION \(.id) --itemid \($parent.id) --output \"./export/attachments/\($parent.id)/\(.fileName)\""')

# create an archive with all exported data
tar czvf $EXPORT_NAME.tar.gz export
rm -rf export/

# encrypt the archive
gpg --symmetric --cipher-algo AES256 $EXPORT_NAME.tar.gz

# delete unencrypted data
rm $EXPORT_NAME.tar.gz
