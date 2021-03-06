#!/bin/bash

# make sure you passed a slack api token
if [ -z "${TOKEN}" ]
then
  echo "Missing TOKEN env var"
  exit 1
fi

# use 2 weeks ago if SINCE isn't provided
if [ -z "${SINCE}" ]
then
  # find date/time in epoch format 2 weeks ago
  SINCE="$(date -d 'now - 2 weeks' +'%s')"
fi

# get slack get deactivated users & filter out bots and non-employees
IFS=$'\n'
for PERSON in $(curl -s "https://slack.com/api/users.list?token=${TOKEN}&pretty=1" | jq -r --arg SINCE "$SINCE" '.members | .[] | select((.deleted == true) and (.updated >= '"$SINCE"') and (.is_bot == false) and (.is_restricted == false)) | "\(.updated) \(.profile.real_name)"' | sort)
do
  echo "$(date -d @"$(echo "${PERSON}" | awk '{print $1}')") -$(echo "${PERSON}" | awk '{first = $1; $1 = ""; print $0}')"
done
