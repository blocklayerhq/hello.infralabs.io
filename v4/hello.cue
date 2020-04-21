// V4: hello world, in the cloud!

package main

input: {
	HelloDocument.input
	...
}
output: {
	html: doc.output.html
	url: website.url
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
