#!/bin/bash

cd ~/Kubernetes/Deployment/Ansible/PiTray || exit 1

echo "🔄 Adding changes recursively..."
git add .

echo "📝 Committing changes..."
git commit -m "Recursive update on $(date '+%Y-%m-%d %H:%M:%S')"

echo "📤 Pushing to GitHub..."
git push origin main

echo "✅ Done."

