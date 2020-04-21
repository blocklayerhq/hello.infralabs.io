package main

import (
    "strings"
    "encoding/json"
    "b.l/bl"
    "stackbrew.io/aws"
    "stackbrew.io/aws/ecs"
    "stackbrew.io/aws/cloudformation"
)

// SimpleECSApp is a simplified interface for ECS
SimpleAppECS :: {
    app: SimpleApp

    infra: {
        awsConfig: aws.Config & {
            accessKey: bl.Secret
            secretKey: bl.Secret
            region: "us-west-2"
        }
        cluster: "bl-api"
        vpcID: "vpc-8b3be8f3"
        elbListenerArn: "arn:aws:elasticloadbalancing:us-west-2:125635003186:listener/app/bl-api-lb-dev/55f5c84913621ac8/ad42f15305f7ac1d"
    }

    subDomain: strings.Split(app.hostname, ".")[0]

    resources: {
        (ecs.Task & {
            containers: [ecs.Container & {
                Name: subDomain
                Image: app.containerImage
                Essential: true
                Command: ["nginx", "-g", "daemon off;"]
                PortMappings: [{
                    ContainerPort: app.containerPort
                    Protocol: "tcp"
                }]
            }]
        }).resources

        (ecs.Service & {
            cluster: infra.cluster
            containerPort: app.containerPort
            containerName: subDomain
            desiredCount: 1
            launchType: "EC2"
            vpcID: infra.vpcID
            elbListenerArn: infra.elbListenerArn
            hostName: app.hostname
            serviceName: subDomain
        }).resources
    }

    cfn: cloudformation.Stack & {
        config: infra.awsConfig
        source: json.Marshal({
            AWSTemplateFormatVersion: "2010-09-09"
            Description: "ECS App deployed with Blocklayer"
            Resources: resources
        })
        stackName: "bl-ecs-\(subDomain)"
    }

    out: cfn.stackOutput
}
