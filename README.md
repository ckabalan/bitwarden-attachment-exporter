# How To Do a Full Bitwarden Export with Attachments

## 1. Create Basic Export

After logging in create your export with the following command:

```bash
bw export --output ./export/bitwarden.json --format json
```

## 2. Download your Attachments

Choose from one of the following export structures. If you don't have the `jq` tool, download it [here](https://stedolan.github.io/jq/).

How does this work? The `bw list items` command outputs a JSON object with all of your credential data. Unlike the `export` command, the `list items` command outputs attachment information. This object is piped to the `jq` command which loops over the items, ignores the items without attachments, and then for each attachment forms a `bw get attachment [...]` command to download the attachment to the right local filename. The list of commands (from the output of `jq`) then passed to `bash` which runs them in sequence, performing the actual download.

This method is preferable to a hard-to-audit python script which understandably makes people uneasy when processing their most sensitive credentials. The command below may not be the easiest to understand but it should be obvious there is no nefarious actions be taken on your data.

### Preferred: Parent ID > Attachment Filename

Most people should use this format.

Format: `./export/attachments/parent_id/attachment_filename`

Example: `./export/attachments/01234567-89ab-cdef-0123-4567890abcde/Backup Codes.txt`

```bash
bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output \"./export/attachments/\($parent.id)/\(.fileName)\""')
```

### Alternative: Parent ID > Attachment Id

Only use this format if your attachment filenames may be incompatible with your target filesystem (such as invalid characters or extreme length). With this method your export will NOT contain the original filename of the attachment.

Format: `./export/attachments/parent_id-attachment_id`

Example: `./export/attachments/01234567-89ab-cdef-0123-4567890abcde-01234567890abcdefghijklmnopqrstu`

```bash
bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output ./export/attachments/\($parent.id)-\(.id)"')
```


## 3. Create an Archive

Combine the export and attachments into a single archive using the command below:

```bash
tar czvf export.tar.gz export
```

## 4. Encrypt It

Encrypt the archive with a password. If you don't have the `gpg` tool, download it [here](https://gnupg.org/).

```bash
gpg --output export.tar.gz.gpg --symmetric export.tar.gz
```

Don't forget to clean up the unencrypted export and attachments!

## 5. Optional - Script the Process

The above commands can be combined to export, download attachments, archive, encrypt, and clean up all in one process.

```bash
bw export --output ./export/bitwarden.json --format json
bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output \"./export/attachments/\($parent.id)/\(.fileName)\""')
tar czvf export.tar.gz export
rm -rf export/
gpg --output export.tar.gz.gpg --symmetric export.tar.gz
rm export.tar.gz
```