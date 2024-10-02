#!/bin/bash -x

# Download depot_id to steam_game_id and name mapping

LATEST_VERSION=`curl -H "Accept: application/json" -L https://github.com/devedse/DeveLanCacheUI_SteamDepotFinder_Runner/releases/latest | sed 's/.*"tag_name":"\([^"]*\).*/\1/'`

curl -L -o /usr/share/logstash/config/app-depot-output-cleaned.csv "https://github.com/devedse/DeveLanCacheUI_SteamDepotFinder_Runner/releases/download/${LATEST_VERSION}/app-depot-output-cleaned.csv"

# Split combined list to two separate lists depot_id -> game_id and depot_id -> game_name
awk -F\; '$3 !~ /denied/ { print $3","$1 }' /usr/share/logstash/config/app-depot-output-cleaned.csv > /usr/share/logstash/config/depotid-steamid.csv
awk -F\; '$3 !~ /denied/ { print $3","$2 }' /usr/share/logstash/config/app-depot-output-cleaned.csv | sed 's/"//'g > /usr/share/logstash/config/depotid-steamname.csv


# Start the original entrypoint
/usr/local/bin/docker-entrypoint
