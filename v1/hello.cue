// V1: hello, world!

package main

input: {
	name: string | *"world"
}
output: {
	html: string
}

output: html:
	"""
	<html>
	  <head>
	    <title>Hello</title>
	  </head>
	  <body>
	    <h1>Hello</h1>
	    Hello, <b>\(input.name)!</b>
	  </body>
	</html>
	"""
