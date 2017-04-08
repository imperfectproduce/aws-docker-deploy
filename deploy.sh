#!/bin/bash

# Download template
curl -LSso Dockerrun.aws.json.template https://raw.githubusercontent.com/relayfoods/aws-docker-deploy/68985924eeb2effb0685de1cb26c72ad32ce398d/Dockerrun.aws.json.template

# Set vars that typically do not vary by app
BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
SHA1=$(git rev-parse HEAD)
VERSION=$BRANCH-$SHA1-$(date +%s)
DESCRIPTION=$(git log -1 --pretty=%B)
ZIP=$VERSION.zip

aws configure set default.region us-east-1

# Authenticate against our Docker registry
eval $(aws ecr get-login)

# Build and push the image
docker build -t $NAME:$VERSION .
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$NAME:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$NAME:$VERSION

# Copy template Dockerrun.aws.json and replace template vars
cp Dockerrun.aws.json.template Dockerrun.aws.json
# Replace the <AWS_ACCOUNT_ID> with the real ID
sed -i.bak "s/<AWS_ACCOUNT_ID>/$AWS_ACCOUNT_ID/" Dockerrun.aws.json
# Replace the <NAME> with the real name
sed -i.bak "s/<NAME>/$NAME/" Dockerrun.aws.json
# Replace the <TAG> with the real version number
sed -i.bak "s/<TAG>/$VERSION/" Dockerrun.aws.json

# Zip up the Dockerrun file (feel free to zip up an .ebextensions directory with it)
zip -r $ZIP Dockerrun.aws.json

aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
aws elasticbeanstalk create-application-version --application-name "$EB_APP_NAME" \
    --version-label $VERSION --description "$DESCRIPTION" --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

# Update the environment to use the new application version
aws elasticbeanstalk update-environment --environment-name $EB_ENV_NAME \
    --version-label $VERSION

# Clean up
rm $ZIP
rm Dockerrun.aws.json
rm Dockerrun.aws.json.bak
rm Dockerrun.aws.json.template
