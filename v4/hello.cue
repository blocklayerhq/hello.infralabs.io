// V4: let's deploy that html!

package main

import (
	"b.l/bl"
	"stackbrew.io/netlify"
	"stackbrew.io/file"
)

input: {
	HelloDocument.input
	netlifyToken: bl.Secret
}

// 1. Generate the doc
doc: HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}

// 2. Wrap the html doc in a directory
htmlDir: file.Create & {
	filename: "/index.html"
	contents: doc.output.html
}

// 3. Deploy!
website: netlify.Site & {
	name: "hello-infralabs-io"
	domain: "hello.infralabs.io"
	contents: htmlDir.result
	account: {
		token: input.netlifyToken
		name: "blocklayer"
	}
}

output: {
	doc.output

	url: website.url
}
