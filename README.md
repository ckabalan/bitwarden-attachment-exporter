bitwarden-attachment-exporter

1. Create:

`bw export --output ./export/bitwarden.json --format json`

2. Download your attachments in the structure you want:

Export as `./export/attachments/parent_id-attachment_id` (example `./export/attachments/01234567-89ab-cdef-0123-4567890abcde-01234567890abcdefghijklmnopqrstu`):

`bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output ./export/attachments/\($parent.id)-\(.id)"')`


Export as './export/attachments/parent_id/attachment_filename` (example `./export/attachments/01234567-89ab-cdef-0123-4567890abcde/Backup Codes.txt`):

`bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output \"./export/attachments/\($parent.id)/\(.fileName)\""')`

3. Create the archive of your choosing:

As a `.tar.gz`: `tar czvf export.tar.gz export`

4. Encrypt it with a password:

`gpg --output export.tar.gz.gpg --symmetric export.tar.gz`


As a script:

```bash
bw export --output ./export/bitwarden.json --format json
bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output \"./export/attachments/\($parent.id)/\(.fileName)\""')
tar czvf export.tar.gz export
rm -rf export/
gpg --output export.tar.gz.gpg --symmetric export.tar.gz
rm export.tar.gz
```
