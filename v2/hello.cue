package main

import (
	"strings"
)

input: {
	// A title
	title: string | *"Demo 1"

	// A greeting
	greeting: string | *"hello"

	// A name, or list of names
	name: string | [...string] | *"world"
}

output: {
	// A markdown-formatted message
	markdown: string

	// An HTML-formatted message
	html: string
}

// Capitalize names, and put them in a list
nameList: [...string]
nameList: [strings.ToTitle(input.name)] | [strings.ToTitle(name) for name in input.name]


// GENERATE MARKDOWN OUTPUT

markdownMessages: ["- \(input.greeting), dear *\(name)*!" for name in nameList]
output: {
	markdown: """
		# \(input.title)

		\(strings.Join(markdownMessages, "\n"))
		"""
}

// GENERATE HTML OUTPUT
htmlMessages: ["<li>\(input.greeting), dear <b>\(name)</b>!</li>" for name in nameList]

output: {
	html:
		"""
		<html>
		    <head>
		        <title>\(input.title)</title>
		    </head>
		    <body>
		        <h1>\(input.title)</h1>
		        <ul>
		        \(strings.Join(htmlMessages, "\n"))
		        </ul>
		    </body>
		</html>
		"""
}
