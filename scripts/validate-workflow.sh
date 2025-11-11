#!/bin/bash

# GitHub Actions Workflow Validation Script
# This script helps validate the workflow configuration locally

set -e

echo "🔍 Validating GitHub Actions workflow configuration..."

# Check if required files exist
echo "📁 Checking workflow files..."
if [ ! -f ".github/workflows/build-and-publish.yml" ]; then
    echo "❌ build-and-publish.yml not found"
    exit 1
fi

if [ ! -f ".github/workflows/release.yml" ]; then
    echo "❌ release.yml not found"
    exit 1
fi

echo "✅ Workflow files found"

# Validate YAML syntax
echo "🔧 Validating YAML syntax..."
if command -v yamllint &> /dev/null; then
    yamllint .github/workflows/*.yml
    echo "✅ YAML syntax is valid"
else
    echo "⚠️  yamllint not found, skipping YAML validation"
fi

# Check Dockerfile
echo "🐳 Checking Dockerfile..."
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile not found"
    exit 1
fi

echo "✅ Dockerfile found"

# Test Docker build (optional)
if [ "$1" = "--build-test" ]; then
    echo "🏗️  Testing Docker build..."
    docker build -t stepdaddylivehd-test .
    echo "✅ Docker build successful"
    
    # Clean up test image
    docker rmi stepdaddylivehd-test
fi

# Check environment variables
echo "🔍 Checking environment configuration..."
if [ -f ".env" ]; then
    echo "✅ .env file found"
else
    echo "⚠️  .env file not found (optional for CI/CD)"
fi

# Validate repository structure
echo "📂 Checking repository structure..."
required_files=("requirements.txt" "rxconfig.py" "StepDaddyLiveHD/__init__.py")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file found"
    else
        echo "❌ $file not found"
        exit 1
    fi
done

echo ""
echo "🎉 Workflow validation completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Commit and push your changes to trigger the workflow"
echo "2. Monitor the build in GitHub Actions tab"
echo "3. Check the published image at ghcr.io/YOUR_USERNAME/stepdaddylivehd"
echo ""
echo "🔗 Useful commands:"
echo "  # Create a release tag"
echo "  git tag v1.0.0"
echo "  git push origin v1.0.0"
echo ""
echo "  # Pull the latest image"
echo "  docker pull ghcr.io/YOUR_USERNAME/stepdaddylivehd:latest"