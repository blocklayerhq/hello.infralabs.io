// V6: let's deploy that html!
package main

import (
	"b.l/bl"
	"stackbrew.io/netlify"
	"stackbrew.io/aws/s3"
	"stackbrew.io/aws/ecr"
)

input: {
	HelloDocument.input
	netlifyToken: bl.Secret
	awsAccessKey: bl.Secret
    awsSecretKey: bl.Secret
}

output: {
	doc.output
	url: urlNetlify
	urlNetlify: website.url
	urlS3: "http://hello-s3.infralabs.io/"
    urlEKS: "https://\(deployEKS.app.hostname)/"
    urlECS: "https://\(deployECS.app.hostname)/"
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

// Shared AWS credentials
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

// Generate the html doc
doc: HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}

// Push the container image (for ECS and EKS)
imagePush: bl.Push & {
	source: doc.containerImage
	target: registry.target
	auth:   registry.auth
}

// Deploy to Netlify!
website: contents: doc.htmlDir
// Deploy to S3!
s3bucket: source: doc.htmlDir
// Deploy to ECS!
deployECS: app: containerImage: imagePush.ref
// Deploy to EKS!
deployEKS: app: containerImage: imagePush.ref
