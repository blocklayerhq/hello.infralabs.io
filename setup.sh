#!/bin/bash

set -o errexit -o nounset -o xtrace

function setup() {
	export BL_API_SERVER=http://localhost:8080/query

	bl domain delete hello.infralabs.io
	bl domain claim hello.infralabs.io

	cat <<-EOF
	TERM 1: 'bl get hello.infralabs.io input'
	TERM 2: 'bl get hello.infralabs.io output.html --raw'
	TERM 3: main term
	EOF

}

setup
