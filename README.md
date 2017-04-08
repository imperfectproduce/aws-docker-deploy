# aws-docker-deploy
Scripts and templates for deploying docker containers to aws / elastic beanstalk

Assumes us-east-1 region

Create a script with project-specific environment variables that downloads and executes the template-driven script in this repo.

    NAME=container-name
    AWS_ACCOUNT_ID=1234567890
    EB_BUCKET=elasticbeanstalk-us-east-1-1234567890 
    EB_APP_NAME=eb-app-name
    EB_ENV_NAME=eb-env-name
    
    curl -LSso Dockerrun.aws.json.template https://raw.githubusercontent.com/relayfoods/aws-docker-deploy/68985924eeb2effb0685de1cb26c72ad32ce398d/Dockerrun.aws.json.template
    eval "$(curl -s -L https://raw.githubusercontent.com/relayfoods/aws-docker-deploy/68985924eeb2effb0685de1cb26c72ad32ce398d/deploy.sh)"

    rm Dockerrun.aws.json.template
