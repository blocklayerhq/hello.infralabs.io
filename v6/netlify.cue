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
		token: admin.netlify.token
		name: "blocklayer"
	}
}
