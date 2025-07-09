# Aqua Security Trivy Premium GitHub Actions Demo

This repository demonstrates how to integrate Aqua Security's Trivy Premium into GitHub Actions workflows. It provides two implementation approaches: Docker-based and CLI-based scanning.

## Overview

The workflows in this repository scan Docker images for vulnerabilities and compliance issues using Aqua's Trivy Premium, then register compliant images with your Aqua platform.

### Available Workflows

1. **Docker Scanner** (`.github/workflows/trivy-docker-scan.yml`)
   - Runs the scanner as a Docker container
   - Pulls the scanner image from Aqua's registry

2. **CLI Scanner** (`.github/workflows/trivy-cli-scan.yml`)
   - Downloads and runs the scanner as a standalone binary
   - Useful for environments where Docker-in-Docker is not preferred

## Prerequisites

Before using these workflows, you need:

1. **Aqua Platform Account**: Access to Aqua's SaaS platform or on-premises installation
2. **Scanner Access**: Credentials to download Trivy Premium
3. **GitHub Repository**: With Actions enabled
4. **Docker Hub Integration**: Configured in your Aqua platform (or modify for your registry)

## Configuration Steps

### 1. Configure Aqua Platform

1. Log into your Aqua platform
2. Navigate to **Workloads Protection** → **Administration** → **Integrations** → **Image Registries**
3. Add a Registry integration
4. Note the exact integration name - this must match `IMAGE_REGISTRY_INTEGRATION` in the workflows

### 2. Generate Authentication Token

1. In Aqua platform, go to **Workloads Protection** → **Administration** → **Scanner Groups**
2. Create a new access CLI group
3. Copy the generated token

### 3. Configure GitHub Secrets

Add the following secrets to your GitHub repository:

| Secret Name | Description | Example |
|------------|-------------|---------|
| `AQUA_SERVER` | Your Aqua platform URL | `https://c1fae5dxxx.cloud.aquasec.com` |
| `TOKEN` | Aqua access token (from step 2) | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `AQUAREG_USER` | Username for registry.aquasec.com | Required only if scanner image not already mirrored |
| `AQUAREG_PSWD` | Password for registry.aquasec.com | Required only if scanner image not already mirrored |

To add secrets:
1. Go to your repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add each secret with its name and value

### 4. Verify Workflow Variables

Both workflows use these environment variables:

```yaml
env:
  IMAGE_NAME: "demo-local-build"           # Your image name
  SCANNER_VERSION: "saas-latest"           # Scanner version
  IMAGE_REGISTRY_INTEGRATION: "Docker Hub" # Must match Aqua integration name
```

Ensure `IMAGE_REGISTRY_INTEGRATION` exactly matches the name of your registry integration in Aqua.

## Usage

### Running the Workflows

The workflows trigger definition is in the action and runs automatically on, unless modified:
- Push to `main` branch
- Pull requests to `main` branch


### What the example Workflows Do

1. **Build**: Creates a Docker image from Dockerfile
2. **Scan**: Analyzes the image for:
   - Vulnerabilities (CVEs)
   - Compliance issues
   - License violations
   - Sensitive data
3. **Register**: If compliant, registers the image with Aqua
4. **Report**: Outputs text scan results to the workflow logs


## Customization

### Scanner Options

Find all the common scanner flags and documentation in the official Aqua Docs → [scanner-command-line-interface](https://docs.aquasec.com/saas/image-and-function-scanning/scanning-manually-with-cli/scanner-command-line-interface/)


### Scanner Versions

- `saas-latest`: Always uses the latest scanner version (recommended for SaaS)
- Specific version (e.g., `2405.22.9`): Pins to a specific release

## Support

- **Aqua Documentation**: [docs.aquasec.com](https://docs.aquasec.com)
- **Aqua Support**: [support.aquasec.com](https://support.aquasec.com)


## License

This demo repository is provided as-is for demonstration purposes.