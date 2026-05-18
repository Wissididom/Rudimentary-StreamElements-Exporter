for i in ${USERS//,/ }
do
    echo $i
    SE_ID=$(curl -s -H 'Accept: application/json; charset=utf-8' -H "Authorization: Bearer $JWT_TOKEN" "https://api.streamelements.com/kappa/v2/channels/$i" | jq -r '._id')
    curl -s -H 'Accept: application/json; charset=utf-8' -H "Authorization: Bearer $JWT_TOKEN" "https://api.streamelements.com/kappa/v2/bot/commands/$SE_ID/default" > "$i-default-commands.json"
    curl -s -H 'Accept: application/json; charset=utf-8' -H "Authorization: Bearer $JWT_TOKEN" "https://api.streamelements.com/kappa/v2/bot/commands/$SE_ID" > "$i-custom-commands.json"
    curl -s -H 'Accept: application/json; charset=utf-8' -H "Authorization: Bearer $JWT_TOKEN" "https://api.streamelements.com/kappa/v2/bot/timers/$SE_ID" > "$i-timers.json"
    curl -s -H 'Accept: application/json; charset=utf-8' -H "Authorization: Bearer $JWT_TOKEN" "https://api.streamelements.com/kappa/v2/bot/filters/$SE_ID" > "$i-filters.json"
    OVERLAYS=$(curl -s -H 'Accept: application/json; charset=utf-8' -H "Authorization: Bearer $JWT_TOKEN" "https://api.streamelements.com/kappa/v2/overlays/$SE_ID")
    echo "$OVERLAYS" > "$i-overlays.json"
    OVERLAY_IDS=$(echo "$OVERLAYS" | jq -r '.docs[]._id')
    for j in $OVERLAY_IDS
    do
        echo "Overlay $j"
        curl -s -H 'Accept: application/json; charset=utf-8' -H "Authorization: Bearer $JWT_TOKEN" "https://api.streamelements.com/kappa/v2/overlays/$SE_ID/$j" > "$i-$j-overlay.json"
        sleep 1
    done
done
