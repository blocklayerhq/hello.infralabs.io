// V3: split out HTML logic

package main

import (
	"strings"
)

#HelloDocument: {
	name:       string | *"world"
	extraNames: [...string] | *[]
	greeting:   string | *"hello"

	// Put all names together, capitalized
	#allNames:     [strings.ToTitle(name)] + [ for n in extraNames { strings.ToTitle(n) } ]
	#htmlMessages: [ for name in #allNames { "      <li>\(greeting), dear <b>\(name)</b>!</li>" } ]

	html:
		"""
		<html>
		    <title>\(greeting)</title>
		    <h1>\(greeting)</h1>
		    <ul>\n\(strings.Join(#htmlMessages, "\n"))
		    </ul>
		</html>
		"""
}
