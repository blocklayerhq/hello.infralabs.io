// V6: hello, multi-cloud world !!

package main

import (
	"blocklayer.dev/bl"
)

input: {
	#HelloDocument.input
	...
}
output: {
	html: doc.output.html
	url: website.url
	urlS3: "http://hello-s3.infralabs.io/"
    urlEKS: "https://\(deployEKS.app.hostname)/"
    urlECS: "https://\(deployECS.app.hostname)/"
}

// Generate the html doc
doc: #HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}

// Deploy to Netlify and S3
website: contents: doc.htmlDir
s3bucket: source: doc.htmlDir

// Push the container image (for ECS and EKS)
imagePush: bl.Push & {
	source: doc.containerImage
	target: registry.target
	// workaround auth bug
	auth: "\(registry.target)": registry.credentials
}

// Deploy to ECS and EKS
deployECS: app: containerImage: imagePush.ref
deployEKS: app: containerImage: imagePush.ref
