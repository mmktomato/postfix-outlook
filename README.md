# postfix-outlook

**FOR THE TESTING PORPUSE ONLY**

Send emails from your local CLI via Outlook.com.

## Usage

```
# Build
$ docker build --build-arg USER=<USER> --build-arg PASSWORD=<PASSWORD> -t my/postfix-outlook .

# Run
$ docker run -it -v /tmp:/mnt --rm my/postfix-outlook

# Send
$ /root/send.sh $ADDR /mnt/path/to/email.html
```

See Dockerfile also.