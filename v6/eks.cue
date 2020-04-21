package main

import (
    "strings"
    "b.l/bl"
    "stackbrew.io/aws"
    "stackbrew.io/aws/eks"
    "stackbrew.io/kubernetes"
)

kubernetesConfigYAML :: {
    containerImage: string
    containerPort: uint
    hostname: string

    content: #"""
        ---
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: backend
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: sandbox
          template:
            metadata:
              labels:
                app: sandbox
            spec:
              containers:
                - name: static-app
                  image: \#(containerImage)
                  command: ["nginx"]
                  args: ["-g", "daemon off;"]
                  ports:
                    - containerPort: \#(containerPort)
        ---
        apiVersion: v1
        kind: Service
        metadata:
          name: backend
        spec:
          selector:
            app: sandbox
          ports:
            - name: backend-port
              port: 1080
              targetPort: \#(containerPort)
        ---
        apiVersion: traefik.containo.us/v1alpha1
        kind: IngressRoute
        metadata:
          name: backendingressroute
        spec:
          entryPoints:
            - web
          routes:
          - match: Host(`\#(hostname)`)
            kind: Rule
            services:
            - name: backend
              port: 1080
        ---
        apiVersion: traefik.containo.us/v1alpha1
        kind: IngressRoute
        metadata:
          name: ingressroutetls
        spec:
          entryPoints:
            - websecure
          routes:
          - match: Host(`\#(hostname)`)
            kind: Rule
            services:
            - name: backend
              port: 1080
          tls:
            certResolver: acmeresolver
        """#
}

SimpleAppEKS :: {
    app: SimpleApp

    infra: {
        awsConfig: aws.Config & {
            accessKey: bl.Secret
            secretKey: bl.Secret
            region: "us-east-2"
        }
        cluster: "bl-docs-demo-eks"
    }

    subDomain: strings.Split(app.hostname, ".")[0]

    // Task that generates the "kubeconfig" auth config
    kubeAuth: eks.KubeConfig & {
        config:  infra.awsConfig
        cluster: infra.cluster
    }

    deploy: kubernetes.Apply & {
        // Kube auth config file generated above
        kubeconfig: kubeAuth.kubeconfig
        // Namespace to use on the Kube cluster
        namespace: "demo-\(subDomain)"
        // Kube config generated from Cue templating (similar to Go)
        source: (kubernetesConfigYAML & {
            containerImage: app.containerImage
            containerPort: app.containerPort
            hostname:      app.hostname
        }).content
    }
}
