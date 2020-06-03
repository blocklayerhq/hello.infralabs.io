package main

import (
	"blocklayer.dev/bl"
)

// Admin panel for infrastructure setup
admin: {
	netlify: {
		token: bl.Secret
	}
	aws: {
		accessKey: bl.Secret
		secretKey: bl.Secret
	}
}
