// V3: reusable hello world!

package main

input: {
	HelloDocument.input
}

doc: HelloDocument & {
	"input": {
		greeting: input.greeting
		name: input.name
		extraNames: input.extraNames
	}
}

output: {
	doc.output
}
