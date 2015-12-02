#!/bin/bash

SLACK_HOSTNAME=${SLACK_HOSTNAME-'gdops.slack.com'};
SLACK_TOKEN='T02H9N6ST/B0FBTCVFD/qiMk6GeLLyNuYPRtW6uVgUKo';
SLACK_CHANNEL='#consul-alerts';
SLACK_BOTNAME=${SLACK_BOTNAME-$(hostname -s)};
SLACK_BOTEMOJI=${SLACK_BOTEMOJI-':computer:'}

SEVERITY=${1-'INFO'};
ICON=':slack:';

case "$SEVERITY" in
  INFO)
    ICON=':page_with_curl:';
    shift;
    ;;
  WARN|WARNING)
    ICON=':warning:';
    shift;
    ;;
  ERROR|ERR)
    ICON=':bangbang:';
    shift;
    ;;
  *)
    ICON=':slack:';
    ;;
esac

MESSAGE=$@;

PAYLOAD="payload={\"channel\": \"${SLACK_CHANNEL}\", \"username\": \"${SLACK_BOTNAME}\", \"text\": \"${ICON} ${MESSAGE}\", \"icon_emoji\": \"${SLACK_BOTEMOJI}\"}";
CURL_RESULT=$(curl -s -S -X POST --data-urlencode "$PAYLOAD" https://hooks.slack.com/services/${SLACK_TOKEN});

echo $CURL_RESULT;