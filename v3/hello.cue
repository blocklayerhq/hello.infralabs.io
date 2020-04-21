// V3: split out HTML logic

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
