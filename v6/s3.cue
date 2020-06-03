// S3 bucket setup

package main

import (
	"stackbrew.io/aws/s3"
)

s3bucket: s3.Put & {
	config: {
		region: "us-west-2"
		accessKey: admin.aws.accessKey
		secretKey: admin.aws.secretKey
	}
	target: "s3://hello-s3.infralabs.io/"
}


