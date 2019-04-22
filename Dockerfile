FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN apk --no-cache add bash coreutils curl jq

COPY slack-last_two_weeks.sh /slack-last_two_weeks.sh

CMD ["/slack-last_two_weeks.sh"]
