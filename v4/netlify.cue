// INFRASTRUCTURE SETUP

package main

import (
	"stackbrew.io/netlify"
)

// Setup Netlify
website: netlify.Site & {
	name: "hello-infralabs-io"
	domain: "hello.infralabs.io"
	account: {
		name: "blocklayer"
		token: admin.netlify.token
	}
}
