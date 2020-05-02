package main

import (
	"strings"
	"blocklayer.dev/bl"
)

devServer: Endpoint

hello: devServer.RunCommand & {
	cmd: ["uname", "-a"]
}


Endpoint :: {
	key: bl.Secret
	user: string
	host: string
	port: int | *22

	RunCommand :: {
		cmd : [...string]
		stdout: output["/output/stdout"]
		stderr: output["/output/stderr"]

		output: _

		bl.BashScript & {
			input: {
				"/key": key
			}
			output: {
				"/output/stdout": string
				"/output/stderr": string
			}
			environment: {
				SSH_USER: user
				SSH_HOST: host
				SSH_PORT: "\(port)"
			}
			code:
				#"""
				ssh \
					-i /key \
					-p "$SSH_PORT" \
					-o StrictHostKeyChecking=accept-new \
					"$SSH_USER@$SSH_HOST" \
					\#(strings.Join(cmd, " ")) \
					> /output/stdout \
					2> /output/stderr
				"""#
			os: package: openssh: true
		}
	}
}
