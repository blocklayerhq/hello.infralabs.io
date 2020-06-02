// V3: reusable hello world!

package main

input: {
	#HelloDocument.input
}
output: {
	html: doc.output.html
}

doc: #HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}
