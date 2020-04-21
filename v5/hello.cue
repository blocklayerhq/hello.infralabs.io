// V5: let's deploy that html to Netlify and S3!
package main

import (
	"b.l/bl"
	"stackbrew.io/netlify"
	"stackbrew.io/file"
	"stackbrew.io/aws"
	"stackbrew.io/aws/s3"
)

// We expose all the inputs and outputs of a HelloDocument
input: {
	HelloDocument.input
	netlifyToken: bl.Secret

	// AWS credentials
	awsAccessKey: bl.Secret
    awsSecretKey: bl.Secret
}

// 1. Generate the document
doc: HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}

// 2. Wrap the document in a directory
htmlDir: file.Create & {
	filename: "/index.html"
	contents: doc.output.html
}

// 3. Deploy to netlify!
website: netlify.Site & {
	name: "hello-infralabs-io"
	domain: "hello.infralabs.io"
	contents: htmlDir.result
	account: token: input.netlifyToken
}

// 4. Deploy to AWS S3
s3bucket: s3.Put & {
	config: aws.Config & {
		region: "us-west-2"
		accessKey: input.awsAccessKey
		secretKey: input.awsSecretKey
	}
	source: htmlDir.result
	target: "s3://hello-s3.infralabs.io/"
}

output: {
	doc.output

	// URL of the website deployed to Netlify
	urlNetlify: website.url

	// URL of the website deployed to AWS S3
	urlS3: "http://hello-s3.infralabs.io/"
}
