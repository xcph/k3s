#!/usr/bin/env bash
# Populates ./deps/containerd from k3s-io/containerd at the tag expected by this
# branch, then applies patches/containerd-pr-12732.patch (upstream containerd#12732).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${ROOT}/deps/containerd"
TAG="${CONTAINERD_TAG:-v2.2.2-k3s1}"
PATCH="${ROOT}/patches/containerd-pr-12732.patch"
REPO="${CONTAINERD_REPO:-https://github.com/k3s-io/containerd.git}"

mkdir -p "${ROOT}/deps"
if [[ ! -d "${DEST}/.git" ]]; then
	git clone --branch "${TAG}" --single-branch "${REPO}" "${DEST}"
else
	git -C "${DEST}" fetch --tags --depth 1 origin "refs/tags/${TAG}:refs/tags/${TAG}" 2>/dev/null || git -C "${DEST}" fetch origin
	git -C "${DEST}" checkout -f "${TAG}"
fi

if [[ ! -f "${PATCH}" ]]; then
	echo "missing patch: ${PATCH}" >&2
	exit 1
fi

git -C "${DEST}" apply --check "${PATCH}"
git -C "${DEST}" apply "${PATCH}"
echo "Applied ${PATCH} on ${DEST} @ ${TAG}"
