#!/bin/bash

# Build and Push Script for ComfyUI-Garage (RunPod, CUDA 13.0, UmeAiRT Toolkit)
# Uses comfyui-base:cu130 as base image (built from runpod/base/Dockerfile.base)

set -e

echo "🐳 Building ComfyUI-Garage Docker image (RunPod, CUDA 13.0, UmeAiRT Toolkit)..."

# Build variables
IMAGE_NAME="huchukato/comfyui-qwenvl-runpod"
TAG="cu13-umeairt"
DOCKERFILE="runpod/Dockerfile.CU13-UmeAiRT"
PLATFORM="linux/amd64"
BASE_IMAGE="huchukato/comfyui-base"
BASE_TAG="cu130"
BASE_CUDA_DASH="13-0"
BASE_TORCH_SUFFIX="cu130"
BASE_TRT_SUFFIX="cu13"
BASE_LLAMA_WHEEL="https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.48-cu131-linux-20260821/llama_cpp_python-0.3.48%2Bcu131-cp312-cp312-linux_x86_64.whl"
BASE_TORCH_VERSION="2.10.0+cu130"
BASE_TORCHVISION_VERSION="0.25.0+cu130"
BASE_TORCHAUDIO_VERSION="2.10.0+cu130"

# Check Docker login
echo "🔐 Checking Docker Hub login..."
if ! docker login 2>&1 | grep -q "Login Succeeded\|Already logged in"; then
    echo "❌ Not logged in to Docker Hub. Please run 'docker login' first."
    exit 1
fi
echo "✅ Docker Hub login confirmed"

# Setup buildx
echo "🔧 Using desktop-linux builder globally..."
docker buildx use --global desktop-linux

# Ensure base image exists locally (pull from Docker Hub)
if ! docker image inspect "${BASE_IMAGE}:${BASE_TAG}" >/dev/null 2>&1; then
    echo "📦 Pulling base image ${BASE_IMAGE}:${BASE_TAG} from Docker Hub..."
    docker pull --platform ${PLATFORM} "${BASE_IMAGE}:${BASE_TAG}"
else
    echo "✅ Base image ${BASE_IMAGE}:${BASE_TAG} already exists locally"
fi

# Build the worker image
echo "📦 Building image: ${IMAGE_NAME}:${TAG} for platform: ${PLATFORM}"
docker buildx build --builder desktop-linux --platform ${PLATFORM} \
    -f ${DOCKERFILE} --build-arg CACHEBUST=$(date +%s) -t ${IMAGE_NAME}:${TAG} --load .

# Push to Docker Hub
echo "🚀 Pushing to Docker Hub..."
docker push ${IMAGE_NAME}:${TAG}

echo "✅ Build and push completed!"
echo "📋 Image: ${IMAGE_NAME}:${TAG}"
echo "🌐 Available on Docker Hub: https://hub.docker.com/r/${IMAGE_NAME}"
