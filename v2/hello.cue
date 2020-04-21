package main

import (
	"strings"
)

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
	  <head>
	    <title>\(input.greeting)</title>
	  </head>
	  <body>
	    <h1>\(input.greeting)</h1>
	    <ul>\n\(strings.Join(htmlMessages, "\n"))</ul>
	  </body>
	</html>
	"""
