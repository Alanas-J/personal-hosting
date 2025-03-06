FROM alpine:3.21.3

# Dependencies
RUN apk upgrade --no-cache && apk add bash jq curl aws-cli

WORKDIR /app
ADD ./dns_sync_loop.sh ./
RUN chmod +x ./dns_sync_loop.sh

CMD ["./dns_sync_loop.sh"]
