// V1: hello, world!

package main

doc: {
	name: string | *"world"
	html:
		"""
		<html>
		    <title>Hello</title>
		    <h1>Hello</h1>
		    Hello, <b>\(name)!</b>
		</html>
		"""
}
