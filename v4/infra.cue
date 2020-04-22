// INFRASTRUCTURE SETUP

package main

import (
	"blocklayer.dev/bl"

	"stackbrew.io/netlify"
)

input: {
	netlifyToken: bl.Secret
	...
}

// Setup Netlify
website: netlify.Site & {
	name: "hello-infralabs-io"
	domain: "hello.infralabs.io"
	account: {
		token: input.netlifyToken
		name: "blocklayer"
	}
}
