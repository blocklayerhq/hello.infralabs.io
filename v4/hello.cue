// V4: let's deploy that html!
package main

import (
	"b.l/bl"
	"stackbrew.io/netlify"
	"stackbrew.io/file"
)

// We expose all the inputs and outputs of a HelloDocument
input: {
	HelloDocument.input

	// Netlify API key
	netlifyToken: bl.Secret
}

// 1. Generate the document
doc: HelloDocument & {
	"input": {
		title: input.title
		greeting: input.greeting
		name: input.name
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

output: {
	doc.output

	// URL of the website
	url: website.url
}
