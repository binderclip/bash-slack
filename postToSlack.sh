#!/usr/bin/env bash

function usage {
    programName=$0
    echo "description: use this program to post messages to Slack by Incoming Webhooks"
    echo "usage: $programName [-t \"text\"] [-u \"slack url\"]"
    echo "  -t    the message text you are posting"
    echo "  -u    The slack hook url to post to"
    exit 1
}

while getopts ":t:u:h" opt; do
  case ${opt} in
    t) msgText="$OPTARG"
    ;;
    u) slackUrl="$OPTARG"
    ;;
    h) usage
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ ! "${msgText}" || ! "${slackUrl}" ]]; then
    echo "all arguments are required"
    usage
fi

read -d '' payLoad << EOF
{
    "text": "${msgText}",
}
EOF


statusCode=$(curl \
        --write-out %{http_code} \
        --silent \
        --output /dev/null \
        -X POST \
        -H 'Content-type: application/json' \
        --data "${payLoad}" ${slackUrl})

echo ${statusCode}
