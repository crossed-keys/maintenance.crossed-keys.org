#!/usr/bin/env bash
cf_api(){
  curl -fsSL -H 'Content-Type:application/json' -H "Authorization: Bearer $CF_CROSSED_KEYS_TOKEN" https://api.cloudflare.com/client/v4/zones/$CF_CROSSED_KEYS_ID/"$@"
}
dns_id=$(cf_api dns_records | jq -r '.result[] | select(.name=="crossed-keys.org" and .type=="CNAME") | .id')
target=${1:-crossed-keys.github.io}
cf_api dns_records/$dns_id -X PUT --data '{
  "content": "'$target'",
  "name": "crossed-keys.org",
  "proxied": false,
  "type": "CNAME",
  "ttl": 1}'
