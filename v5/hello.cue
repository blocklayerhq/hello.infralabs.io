// V5: let's deploy that html to Netlify and S3!

package main

input: {
	HelloDocument.input
	...
}
output: {
	html: doc.output.html
	url: website.url
	urlS3: "http://hello-s3.infralabs.io/"
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

