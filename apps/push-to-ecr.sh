#!/bin/bash

# Variáveis
AWS_REGION="us-east-1"
ECR_REPO_APP_NODE="547886934166.dkr.ecr.$AWS_REGION.amazonaws.com/app-node"
ECR_REPO_APP_PYTHON="547886934166.dkr.ecr.$AWS_REGION.amazonaws.com/app-python"
TAG="v1.0"
AWS_ACCOUNT_ID="547886934166"

# Faça login no ECR
echo "Fazendo login no ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Construa as imagens
echo "Construindo imagem para app-node..."
docker build -t app-node ./node-app

echo "Construindo imagem para app-python..."
docker build -t app-python ./python-app

# Tagueie as imagens com a tag v1.0
echo "Tag a imagem app-node com a tag $TAG..."
docker tag app-node:latest $ECR_REPO_APP_NODE:$TAG

echo "Tag a imagem app-python com a tag $TAG..."
docker tag app-python:latest $ECR_REPO_APP_PYTHON:$TAG

# Envie as imagens para o ECR
echo "Enviando a imagem app-node para o ECR..."
docker push $ECR_REPO_APP_NODE:$TAG

echo "Enviando a imagem app-python para o ECR..."
docker push $ECR_REPO_APP_PYTHON:$TAG

echo "Push para o ECR concluído com sucesso!"
