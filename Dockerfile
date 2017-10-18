FROM tophfr/mailcatcher

EXPOSE 1025 8080

CMD ["mailcatcher", "--foreground", "--ip=0.0.0.0", "--smtp-port=1025", "--http-port=8080"]
