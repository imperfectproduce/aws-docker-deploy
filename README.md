# aws-docker-deploy
Scripts and templates for deploying docker containers to aws / elastic beanstalk ("Single Container" style with [v1 Dockerrun.aws.json](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_image.html#create_deploy_docker_image_dockerrun)).

The script does the following

- Builds the docker image
- Uploads the docker image to ECR
- Creates and uploads new beanstalk application version to S3
- Deploys new beanstalk version to target environment

The docker image is tagged with `<branch name>-<commit hash>-<timestamp>` which is also used as the beanstalk application version.

Assumes us-east-1 region

Create a project specific deploy script like the following

    # project-specific environment variables
    NAME=container-name
    AWS_ACCOUNT_ID=1234567890
    EB_BUCKET=elasticbeanstalk-us-east-1-1234567890 
    EB_APP_NAME=eb-app-name
    EB_ENV_NAME=eb-env-name
    
    # download and execute deploy.sh in the current shell
    eval "$(curl -s -L https://raw.githubusercontent.com/relayfoods/aws-docker-deploy/41f9dc7d35353b5731153c6f4d592ca966945d51/deploy.sh)"
    
Note the revision specific curl sources, see https://help.github.com/articles/getting-permanent-links-to-files/

Credit to https://gist.github.com/yefim/93fb5aa3291b3843353794127804976f for original inspiration / code reference.
