# aws-docker-deploy
Scripts and templates for deploying docker containers to aws / elastic beanstalk

Assumes us-east-1 region

Create a script with the following environment variables

    NAME=container-name
    AWS_ACCOUNT_ID=1234567890
    EB_BUCKET=elasticbeanstalk-us-east-1-1234567890 
    EB_APP_NAME=eb-app-name
    EB_ENV_NAME=eb-env-name

and curl to download and execute tempalte and scripts (see https://help.github.com/articles/getting-permanent-links-to-files/ for getting a revision specific permalink).
