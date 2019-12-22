bitwarden-attachment-exporter

1. Export Your Files:

`bw export --output ./export/bitwarden.json --format json`

2. Download your attachments in the structure you want:

Export as `attachments/parent_id-attachment_id` (example `attachments/01234567-89ab-cdef-0123-4567890abcde-01234567890abcdefghijklmnopqrstu`):

`bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output ./export/attachments/\($parent.id)-\(.id)"'`


Export as 'attachments/parent_id/attachment_filename` (example `attachments/01234567-89ab-cdef-0123-4567890abcde/Backup Verification Codes.txt`):

`bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | bw get attachment \(.id) --itemid \($parent.id) --output ./export/attachments/\($parent.id)/\(.fileName)"'`

Export as 'attachments/item/folder/structure/attachment_filename` (example ``):

``
