// V6: hello, multi-cloud world !!

package main

doc: #HelloDocument
website: contents: doc.htmlDir
s3bucket: source: doc.htmlDir

container: contents: doc.htmlDir

// Deploy to ECS and EKS
deployECS: app: containerImage: container.pushedTo
deployEKS: app: containerImage: container.pushedTo
