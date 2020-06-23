#!/bin/bash
set -e

# Download template
curl -LSso Dockerrun.aws.json.template https://raw.githubusercontent.com/imperfectproduce/aws-docker-deploy/c13ffa2eda068d5d4eee93ce498d1340f72a529c/Dockerrun.aws.json.template

# Set vars that typically do not vary by app
BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
SHA1=$(git rev-parse --short HEAD)
VERSION=$BRANCH-$SHA1-$(date +%s)
DESCRIPTION=$(git log -1 --pretty=%B)
DESCRIPTION=${DESCRIPTION:0:180} # truncate to 180 chars - max beanstalk version description is 200
ZIP=$VERSION.zip

aws configure set default.region $AWS_REGION

# Authenticate against our Docker registry
eval $(aws ecr get-login --region $AWS_REGION | sed "s/-e none //")

# Build and push the image
docker build -t $NAME:$VERSION .
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$NAME:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$NAME:$VERSION

# Copy template Dockerrun.aws.json and replace template vars
cp Dockerrun.aws.json.template Dockerrun.aws.json

# Replace the template values
sed -i.bak "s/<AWS_ACCOUNT_ID>/$AWS_ACCOUNT_ID/" Dockerrun.aws.json
sed -i.bak "s/<AWS_REGION>/$AWS_REGION/" Dockerrun.aws.json
sed -i.bak "s/<NAME>/$NAME/" Dockerrun.aws.json
sed -i.bak "s/<TAG>/$VERSION/" Dockerrun.aws.json
sed -i.bak "s/<CONTAINER_PORT>/$CONTAINER_PORT/" Dockerrun.aws.json

# Zip up the Dockerrun file (feel free to zip up an .ebextensions directory with it)
if [ -d ".ebextensions" ]; then
   zip -r $ZIP Dockerrun.aws.json .ebextensions
else
   zip -r $ZIP Dockerrun.aws.json
fi

aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
aws elasticbeanstalk create-application-version --application-name "$EB_APP_NAME" \
    --version-label $VERSION --description "$DESCRIPTION" --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

# Update the environment to use the new application version
if [ -z "$DEPLOY_TO_EB_ENVS" ]; then
    echo "DEPLOY_TO_EB_ENVS is not set, skipping deployment step"
else
  for env in ${DEPLOY_TO_EB_ENVS[@]}; do
    aws elasticbeanstalk update-environment --environment-name $env \
        --version-label $VERSION
  done
fi

# Clean up
rm $ZIP
rm Dockerrun.aws.json
rm Dockerrun.aws.json.bak
rm Dockerrun.aws.json.template
