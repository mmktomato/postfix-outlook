#!/bin/sh

FROM=$1
TO=$1
SUBJECT=test
BODY=`cat $2`

ENVELOP=`cat << EOH
From:$FROM
Subject:$SUBJECT
Mime-Version:1.0
Content-Type:text/html

$BODY
.
EOH
`

echo "$ENVELOP"
echo "$ENVELOP" | sendmail -t $TO