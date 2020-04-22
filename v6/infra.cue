// INFRASTRUCTURE SETUP

package main

import (
	"blocklayer.dev/bl"

	"stackbrew.io/aws/s3"
	"stackbrew.io/aws/ecr"
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

awsCreds: {
	accessKey: input.awsAccessKey
	secretKey: input.awsSecretKey
}

// Setup AWS S3
s3bucket: s3.Put & {
	config: {
		awsCreds
		region: "us-west-2"
	}
	target: "s3://hello-s3.infralabs.io/"
}

// Setup AWS container registry
registry: ecr.Credentials & {
	config: {
		awsCreds
		region: "us-east-2"
	}
	target: "125635003186.dkr.ecr.us-east-2.amazonaws.com/docs-demo:nginx-static"
}

// Setup AWS ECS (Elastic Container Service)
deployECS: SimpleAppECS & {
	infra: awsConfig: awsCreds
	app: hostname: "hello-ecs.infralabs.io"
}

// Setup AWS EKS (Elastic Kubernetes Service)
deployEKS: SimpleAppEKS & {
	infra: awsConfig: awsCreds
	app: hostname: "hello-kube.infralabs.io"
}
