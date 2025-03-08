#!/bin/bash
set -e  # Exit/crash on any command failure

# Config Variables Used in this script (AWS CLI CREDS ARE ALSO NEEDED):
AWS_HOSTED_ZONE_ID=$AWS_HOSTED_ZONE_ID
DOMAIN_NAME=$DOMAIN_NAME
TYPE="A"
TTL="300"
INIT_SLEEP_TIME="${INIT_SLEEP_TIME:-120}"
LOOP_SLEEP_TIME="${LOOP_SLEEP_TIME:-300}"


echo "DNS Loop Script Start: $(date)"
echo "Sleeping for: ${INIT_SLEEP_TIME}s before starting to reduce crash loop speed if occurs..."
sleep $INIT_SLEEP_TIME


while true; do
    echo "Checking current IP..."
    CURRENT_IP=$(curl http://checkip.amazonaws.com/)

    if [ "$CURRENT_IP" != "$PREVIOUS_IP" ]; then
        echo "Current IP: $CURRENT_IP differs from Cached IP: ${PREVIOUS_IP:-"None"})"

        ROUTE_53_IP=$(aws route53 list-resource-record-sets --hosted-zone-id "$AWS_HOSTED_ZONE_ID" | 
            jq -r '.ResourceRecordSets[] | select (.Name == "'"$DOMAIN_NAME"'") | select (.Type == "'"$TYPE"'") | .ResourceRecords[0].Value') 
        echo "The IP set in Route 53 is: $ROUTE_53_IP"

        if [ "$CURRENT_IP" != "$ROUTE_53_IP" ]; then
            echo "Route 53 IP record is out of sync, setting..."

            JSON_PAYLOAD=$(cat <<- HereDoc
                {
                    "Comment":"Updated From DDNS Shell Script",
                    "Changes":[
                        {
                            "Action":"UPSERT",
                            "ResourceRecordSet": {
                                "ResourceRecords": [
                                    {
                                        "Value":"$CURRENT_IP"
                                    }
                                ],
                                "Name":"$DOMAIN_NAME",
                                "Type":"$TYPE",
                                "TTL":$TTL 
                            }
                        }
                    ]
                }
HereDoc
)

            aws route53 change-resource-record-sets --hosted-zone-id $AWS_HOSTED_ZONE_ID --change-batch "$JSON_PAYLOAD"
            echo "Change requested sucesfully."

        fi
    else
        echo "IP is in sync."
    fi

    PREVIOUS_IP=$CURRENT_IP
    sleep $LOOP_SLEEP_TIME
done
