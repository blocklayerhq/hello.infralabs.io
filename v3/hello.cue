package main

// We expose all the inputs and outputs of a HelloDocument
input: {
	HelloDocument.input
}

doc: HelloDocument & {
	"input": {
		title: input.title
		greeting: input.greeting
		name: input.name
	}
}

output: {
	doc.output
}
