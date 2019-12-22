bitwarden-attachment-exporter

Paranoid Mode: 

`bw list items | jq '[.[] | select(.attachments != null) | {id: .id, attachments: (.attachments[] | {id: .id, fileName: .fileName, url: .url})}]'`

or 
`bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output attachments/\($parent.id)-\(.id)"'`
