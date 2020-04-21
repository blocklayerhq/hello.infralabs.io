package main

SimpleApp :: {
    hostname: string
    containerImage: string
    containerPort: *80 | uint
}
