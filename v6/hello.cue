// V6: let's deploy that html!
package main

import (
	"b.l/bl"
	"stackbrew.io/netlify"
	"stackbrew.io/file"
	"stackbrew.io/aws"
	"stackbrew.io/aws/s3"
	"stackbrew.io/aws/ecr"
)

// We expose all the inputs and outputs of a HelloDocument
input: {
	HelloDocument.input

	// Netlify API key
	netlifyToken: bl.Secret

	// AWS Access Key
	awsAccessKey: bl.Secret

	// AWS Secret Key
    awsSecretKey: bl.Secret
}

// 1. Generate the document
doc: HelloDocument & {
	"input": {
		title: input.title
		greeting: input.greeting
		name: input.name
	}
}

// 2. Wrap the document in a directory
htmlDir: file.Create & {
	filename: "/index.html"
	contents: doc.output.html
}

// 3. Deploy to netlify!
website: netlify.Site & {
	name: "hello-infralabs-io"
	domain: "hello.infralabs.io"
	contents: htmlDir.result
	account: token: input.netlifyToken
}

// 4. Configure our AWS credentials
awsCreds: {
	accessKey: input.awsAccessKey
	secretKey: input.awsSecretKey
}

// 5. Deploy the same static website to S3
deployS3: s3.Put & {
	config: aws.Config & {
		region: "us-west-2"
		awsCreds
	}
	source: htmlDir.result
	target: "s3://hello-s3.infralabs.io/"
}

// 6. Build a Docker image containing the website, served by Nginx
dockerImage: bl.Build & {
	context: htmlDir.result
	dockerfile: """
		FROM nginx
		COPY . /usr/share/nginx/html
		"""
}

imageTarget: "125635003186.dkr.ecr.us-east-2.amazonaws.com/docs-demo:nginx-static"

// 7. Login to AWS ECR so we can push
ecrCredentials: ecr.Credentials & {
	config: aws.Config & {
		region: "us-east-2"
		awsCreds
	}
	target: imageTarget
}

// 8. Push the docker image to AWS ECR
imagePush: bl.Push & {
	source: dockerImage.image
	target: imageTarget
	auth:   ecrCredentials.auth
}

// 9. Deploy the Docker image to AWS ECS
deployECS: SimpleAppECS & {
	infra: awsConfig: awsCreds
	app: {
		hostname: "hello-ecs.infralabs.io"
		containerImage: imagePush.ref
	}
}

// 10. Deploy the Docker image to Kubernetes EKS
deployEKS: SimpleAppEKS & {
	infra: awsConfig: awsCreds
	app: {
		hostname: "hello-kube.infralabs.io"
		containerImage: imagePush.ref
	}
}

output: {
	doc.output

	// URL of the website deployed to Netlify
	urlNetlify: website.url

	// URL of the website deployed to AWS S3
	urlS3: "http://hello-s3.infralabs.io/"

	// URL of the website deployed to AWS EKS
    urlEKS: "https://\(deployEKS.app.hostname)/"

	// URL of the website deployed to AWS ECS
    urlECS: "https://\(deployECS.app.hostname)/"

	// Docker Image pushed to AWS ECR
    imageRef: imagePush.ref
}
