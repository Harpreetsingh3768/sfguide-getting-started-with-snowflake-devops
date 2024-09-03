USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE IF NOT EXISTS QUICKSTART_WH WAREHOUSE_SIZE = XSMALL, AUTO_SUSPEND = 300, AUTO_RESUME= TRUE;


-- Separate database for git repository
CREATE DATABASE IF NOT EXISTS QUICKSTART_COMMON;

/*
-- API integration is needed for GitHub integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/<insert GitHub username>') -- INSERT YOUR GITHUB USERNAME HERE
  ENABLED = TRUE;


-- Git repository object is similar to external stage
CREATE OR REPLACE GIT REPOSITORY quickstart_common.public.quickstart_repo
  API_INTEGRATION = git_api_integration
  ORIGIN = '<insert URL of forked GitHub repo>'; -- INSERT URL OF FORKED REPO HERE
*/

 CREATE OR REPLACE SECRET git_secret_token
  TYPE = password
  USERNAME = 'harpreetsingh3768'
  PASSWORD = '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';

CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/Harpreetsingh3768')
  ALLOWED_AUTHENTICATION_SECRETS = (git_secret_token)
  ENABLED = TRUE;

 

CREATE OR REPLACE GIT REPOSITORY sfgithub_demo
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = git_secret_token
  ORIGIN = 'https://github.com/Harpreetsingh3768/sfguide-getting-started-with-snowflake-devops.git';
 

CREATE OR REPLACE DATABASE QUICKSTART_PROD;


-- To monitor data pipeline's completion
CREATE OR REPLACE NOTIFICATION INTEGRATION email_integration
  TYPE=EMAIL
  ENABLED=TRUE;


-- Database level objects
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;


-- Schema level objects
CREATE OR REPLACE FILE FORMAT bronze.json_format TYPE = 'json';
CREATE OR REPLACE STAGE bronze.raw;


-- Copy file from GitHub to internal stage
copy files into @bronze.raw from @quickstart_common.public.quickstart_repo/branches/main/data/airport_list.json;
