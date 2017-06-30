# aws-docker-deploy
Scripts and templates for deploying docker containers to aws / elastic beanstalk ("Single Container" style with [v1 Dockerrun.aws.json](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_image.html#create_deploy_docker_image_dockerrun)).

The script does the following

- Builds the docker image
- Uploads the docker image to ECR
- Creates and uploads new beanstalk application version to S3
- Deploys new beanstalk version to target environment

The docker image is tagged with `<branch name>-<commit hash>-<timestamp>` which is also used as the beanstalk application version.

Create a project specific deploy script like the following

    # e.g. project-specific build script to prepare artifacts needed by Dockerfile 
    ./build.sh
    
    # project-specific environment variables
    NAME=container-name
    AWS_ACCOUNT_ID=1234567890
    EB_BUCKET=elasticbeanstalk-us-east-1-1234567890 
    EB_APP_NAME="EB App Name"
    EB_ENV_NAME=eb-env-name
    CONTAINER_PORT=80
    AWS_REGION=us-east-1
    
    # download and execute deploy.sh in the current shell
    eval "$(curl -s -L https://raw.githubusercontent.com/relayfoods/aws-docker-deploy/80420f43f1657e501b4636e4dfe9072148d72879/deploy.sh)"
    
Note the revision specific curl sources, see https://help.github.com/articles/getting-permanent-links-to-files/

Credit to [Yefim Vedernikoff](https://gist.github.com/yefim) for [original inspiration / code reference](https://gist.github.com/yefim/93fb5aa3291b3843353794127804976f).
