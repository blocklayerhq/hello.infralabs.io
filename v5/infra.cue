// INFRASTRUCTURE SETUP

package main

import (
	"blocklayer.dev/bl"

	"stackbrew.io/aws/s3"
	"stackbrew.io/netlify"
)

input: {
	netlifyToken: bl.Secret
	awsAccessKey: bl.Secret
    awsSecretKey: bl.Secret
	...
}

// Setup Netlify
website: netlify.Site & {
	name: "hello-infralabs-io"
	domain: "hello.infralabs.io"
	account: {
		token: input.netlifyToken
		name: "blocklayer"
	}
}

// Setup S3
s3bucket: s3.Put & {
	config: {
		region: "us-west-2"
		accessKey: input.awsAccessKey
		secretKey: input.awsSecretKey
	}
	target: "s3://hello-s3.infralabs.io/"
}

