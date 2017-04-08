# aws-docker-deploy
Scripts and templates for deploying docker containers to aws / elastic beanstalk

Assumes us-east-1 region

Create a project specific deploy script like the following 

    # project-specific environment variables
    NAME=container-name
    AWS_ACCOUNT_ID=1234567890
    EB_BUCKET=elasticbeanstalk-us-east-1-1234567890 
    EB_APP_NAME=eb-app-name
    EB_ENV_NAME=eb-env-name
    
    # download Dockerrun.aws.json.template
    curl -LSso Dockerrun.aws.json.template https://raw.githubusercontent.com/relayfoods/aws-docker-deploy/68985924eeb2effb0685de1cb26c72ad32ce398d/Dockerrun.aws.json.template
    # download and execute deploy.sh in the current shell
    eval "$(curl -s -L https://raw.githubusercontent.com/relayfoods/aws-docker-deploy/68985924eeb2effb0685de1cb26c72ad32ce398d/deploy.sh)"

    # clean up
    rm Dockerrun.aws.json.template
