# SBX Factory Demo

This repo demonstrates a minimal setup for a locally run software factory using Docker Sandboxes and Claude Code.

It contains the following sandbox environments:

- **[📦 claude-develop](./envs/claude-develop/sbxenv.yaml)**: Reads a GitHub issue, creates a feature branch, implements the issue using [superpowers](https://github.com/obra/superpowers) and creates a pull request
- **[📦 claude-review](./envs/claude-review/sbxenv.yaml)**: Reads a GitHub pull request, checks out the feature branch and posts a review on GitHub

## Getting Started

You will need:

- A paid Claude Pro account for running Claude Code
- A free Docker account to run Docker Sandboxes
- A GitHub account to create a private sample project

Install [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/install/).

Sign in to Docker:

```sh
sbx login
```

Create a private GitHub repo (e.g. https://github.com/owner/repo) as a sample project.

The Claude subscription login and the GitHub access token are stored on the host by `sbx secrets` and never enter the sandboxes. Run the authenticate script to set up the secrets on the host and test sandboxed access to Claude and GitHub:

```sh
./authenticate.sh
```

Create a new issue in the sample project (e.g. https://github.com/owner/repo/issues/1):

```
Scaffold a static website with a gray background that says "Hello World".
```

Run the development phase for the issue:

```sh
./develop.sh "https://github.com/owner/repo/issues/1"
```

Run the review phase for the created pull request:

```sh
./review.sh "https://github.com/owner/repo/pull/1"
```
