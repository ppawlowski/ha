# Readme

## Description

Set of scripts and manifests to create AWS environment for [sample Phalcon PHP application](https://github.com/asemhostaway/invo) 

## Usage

Makefile is a wrapper for all actions.

In order to deploy everything, you need to run:

1. Define environment:

```bash
  make set-environment env=prod 
```

2. Deploy everything:

```bash
  make deploy-all
```

For detailed list of possible actions, run:

```bash
  make help
```
