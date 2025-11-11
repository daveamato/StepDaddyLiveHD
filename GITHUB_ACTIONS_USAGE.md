# GitHub Actions CI/CD for StepDaddyLiveHD

This document explains how to use the GitHub Actions workflow for building and publishing the StepDaddyLiveHD container to GitHub Container Registry (GHCR).

## Overview

The project includes two GitHub Actions workflows:

1. **Build and Publish** (`.github/workflows/build-and-publish.yml`) - Triggers on pushes to main branch
2. **Release** (`.github/workflows/release.yml`) - Triggers on git tags for releases

## Workflow Triggers

### Automatic Builds
- **Push to master**: Automatically builds and publishes `:latest` tag
- **Pull requests**: Builds for testing (doesn't publish)
- **Git tags**: Creates release versions when tags like `v1.0.0` are pushed

### Manual Builds
You can also trigger builds manually from the GitHub Actions tab in your repository.

## Versioning Strategy

### Tags Generated
- `latest`: Always points to the most recent successful build from master branch
- `master-{commit-sha}`: Unique identifier for each commit
- `v1.0.0`, `v1.1.0`, etc.: Semantic version tags from git tags
- `v1.0`, `v1.1`, etc.: Major.minor versions from git tags
- `stable`: Points to the latest tagged release

### Creating Releases

To create a new release:

1. **Tag your commit:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **The release workflow will automatically:**
   - Build the container image
   - Tag it with semantic version (e.g., `v1.0.0`)
   - Tag it as `stable`
   - Publish to GHCR

## Container Images

### Repository
Your container images will be available at:
```
ghcr.io/YOUR_USERNAME/stepdaddylivehd
```

### Pulling Images

**Latest version:**
```bash
docker pull ghcr.io/YOUR_USERNAME/stepdaddylivehd:latest
```

**Specific version:**
```bash
docker pull ghcr.io/YOUR_USERNAME/stepdaddylivehd:v1.0.0
```

**Stable release:**
```bash
docker pull ghcr.io/YOUR_USERNAME/stepdaddylivehd:stable
```

### Running the Container

**Basic usage:**
```bash
docker run -p 3000:3000 ghcr.io/YOUR_USERNAME/stepdaddylivehd:latest
```

**With custom configuration:**
```bash
docker run -p 8080:3000 \
  -e API_URL=https://yourdomain.com \
  -e PROXY_CONTENT=FALSE \
  -e SOCKS5=user:pass@proxy.example.com:1080 \
  ghcr.io/YOUR_USERNAME/stepdaddylivehd:latest
```

**Using docker-compose:**
```yaml
version: '3.8'
services:
  step-daddy-live-hd:
    image: ghcr.io/YOUR_USERNAME/stepdaddylivehd:latest
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - API_URL=https://yourdomain.com
      - PROXY_CONTENT=TRUE
      - SOCKS5=
    restart: unless-stopped
```

## Build Configuration

### Build Arguments
The workflow uses these default build arguments:
- `PORT=3000`
- `PROXY_CONTENT=TRUE`

### Multi-Platform Support
Images are built for both:
- `linux/amd64` (standard x64)
- `linux/arm64` (Apple Silicon, ARM servers)

### Caching
The workflow uses GitHub Actions cache for faster builds:
- Cache type: `gha` (GitHub Actions cache)
- Cache mode: `max` (maximum caching)

## Permissions Required

The workflows require these permissions in your repository:

```yaml
permissions:
  contents: read
  packages: write
```

These are automatically configured in the workflow files.

## Environment Variables

### Runtime Variables
You can configure the application at runtime using these environment variables:

- `PORT`: Port to run the application on (default: 3000)
- `API_URL`: Domain/IP where the server is reachable
- `PROXY_CONTENT`: Proxy video content through your server (default: TRUE)
- `SOCKS5`: SOCKS5 proxy configuration (optional)

### Build-time Variables
If you need to customize build arguments, you can:
1. Modify the workflow files directly
2. Use repository secrets for sensitive values
3. Create environment-specific workflows

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure your repository has packages write permissions
2. **Build Failures**: Check the Actions tab for detailed error logs
3. **Image Not Found**: Verify the image name and tag are correct

### Debugging

1. **Check Workflow Logs**: Go to Actions tab in your GitHub repository
2. **Test Locally**: Build the image locally using the same Dockerfile
3. **Verify Configuration**: Check environment variables and build arguments

## Best Practices

1. **Semantic Versioning**: Use consistent version tags (v1.0.0, v1.0.1, etc.)
2. **Test Before Release**: Use pull requests to test builds before merging
3. **Monitor Builds**: Keep an eye on build times and success rates
4. **Security**: Regularly update base images and dependencies

## Migration from Local Builds

If you were previously building locally:

1. **Update your docker-compose.yml:**
   ```yaml
   services:
     step-daddy-live-hd:
-      build:
-        context: .
-        dockerfile: Dockerfile
+      image: ghcr.io/YOUR_USERNAME/stepdaddylivehd:latest
   ```

2. **Remove local images:**
   ```bash
   docker image rm step-daddy-live-hd
   ```

3. **Pull the new image:**
   ```bash
   docker-compose pull
   docker-compose up -d
   ```

## Support

If you encounter issues with the GitHub Actions workflow:

1. Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
2. Review the workflow logs in your repository
3. Ensure your repository has the correct permissions
4. Verify your Dockerfile is compatible with the build process