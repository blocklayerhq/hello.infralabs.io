// V4: hello world, in the cloud!

package main

import (
	"b.l/bl"
	"stackbrew.io/netlify"
)

input: {
	HelloDocument.input
	netlifyToken: bl.Secret
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

// Generate the html doc
doc: HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}

// Deploy to Netlify
website: contents: doc.htmlDir

output: {
	doc.output
	url: website.url
}
