// V5: let's deploy that html to Netlify and S3!

package main

import (
	"b.l/bl"
	"stackbrew.io/netlify"
	"stackbrew.io/aws/s3"
)

input: {
	HelloDocument.input
	netlifyToken: bl.Secret
	awsAccessKey: bl.Secret
    awsSecretKey: bl.Secret
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


// Generate the html doc
doc: HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}

// Deploy to Netlify and S3
website: contents: doc.htmlDir
s3bucket: source: doc.htmlDir

output: {
	doc.output
	url: website.url
	urlS3: "http://hello-s3.infralabs.io/"
}
