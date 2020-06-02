package main

import (
	"strings"

	"stackbrew.io/file"
)

#HelloDocument : {

	input: {
		name: string | *"world"
		extraNames: [...string] | *[]
		greeting: string | *"hello"
	}
	
	output: {
		html: string
	}
	
	// Put all names together, capitalized
	allNames: [strings.ToTitle(input.name)] + [strings.ToTitle(n) for n in input.extraNames]
	
	
	htmlMessages: ["      <li>\(input.greeting), dear <b>\(name)</b>!</li>" for name in allNames]
	
	output: html:
		"""
		<html>
		    <title>\(input.greeting)</title>
		    <h1>\(input.greeting)</h1>
		    <ul>\n\(strings.Join(htmlMessages, "\n"))
		    </ul>
		</html>
		"""

	// Wrap the html doc in a directory, for easy deployment
	createHtmlDir: file.Create & {
		filename: "/index.html"
		contents: output.html
	}
	htmlDir: createHtmlDir.result
}
