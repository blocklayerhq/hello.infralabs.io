package main

import (
	"blocklayer.dev/bl"
	"stackbrew.io/aws/ecr"
)

container: #WebsiteContainer & {
	pushTo: "125635003186.dkr.ecr.us-east-2.amazonaws.com/docs-demo:nginx-static"
}

#WebsiteContainer: {
	contents: bl.Directory
	pushTo: string
	pushedTo: push.ref

	build: bl.Build & {
		context: contents
		dockerfile:
			"""
			FROM nginx
			COPY . /usr/share/nginx/html
			"""
	}

	push: bl.Push & {
		source: build.image
		target: pushTo
		// workaround auth bug
		auth: "\(pushTo)": getCreds.credentials
	}

	getCreds: ecr.Credentials & {
		config: {
			region: string | *"us-east-2"
			accessKey: admin.aws.accessKey
			secretKey: admin.aws.secretKey
		}
		target: pushTo
	}
}
