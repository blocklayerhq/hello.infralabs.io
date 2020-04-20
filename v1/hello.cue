package main

input: {
	// A name
	name: string | *"world"
}

output: {
	// A markdown-formatted message
	markdown: string

	// An HTML-formatted message
	html: string
}

// GENERATE MARKDOWN OUTPUT

output: {
	markdown: """
		# Hello

		Hello, *\(input.name)*!
		"""
}

// GENERATE HTML OUTPUT

output: {
	html:
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
}
