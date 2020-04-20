// V4: let's deploy that html!
package main

import (
	"b.l/bl"
	// "stackbrew.io/netlify"
	// "stackbrew.io/file"
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

ls: bl.BashScript & {
	input: "/index.html": doc.output.html
	code: "cat -n -e /index.html"
}

// 2. Wrap the document in a directory
// htmlDir: file.Create & {
// 	filename: "/index.html"
// 	contents: doc.output.html
// }

// 3. Deploy to netlify!
//website: netlify.Site & {
//	account: token: input.netlifyToken
//	contents: htmlDir.result
//}

output: {
	doc.output

	// URL of the website
	//url: website.url
}
