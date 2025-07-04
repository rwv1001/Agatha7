# rails-postgres-docker-skeleton
This skeleton project allows you to develop an application in rails/postgres and deploy it to a webserver using NGINX Proxy Manager. To use this skeleton, first make sure docker is installed.
Then clone this repository:
git clone https://github.com/rwv1001/rails-postgres-docker-skeleton.git my_app

Then create a .env file containing the following (edited appropriately):
ENV_POSTGRES_HOST=db
ENV_POSTGRES_DB=my_app_production
ENV_POSTGRES_DEV_DB=my_app_development
ENV_POSTGRES_USER=****
ENV_POSTGRES_PASSWORD=****
ENV_RAILS_MASTER_KEY=****
ENV_IMAGE_NAME=github-id/my_app
ENV_IMAGE_TAG=****

To run the development containers, execute 'docker compose up  up -d --build', and visit http://localhost:3000/posts to see application.

To deploy, edit deploy.sh, login to your dockerhub account by running 'docker login' from the command line. Then execute './deploy.sh'. Then assuming NGINX Proxy Manager is installed on your webserver, you can see your deployed web application by going to the URL PROD_SERVER specified in deploy.sh.
