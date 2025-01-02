For Apache, you could add something like this to the httpd.conf or .htaccess file:

bash
Copy code
SetEnv AWS_ACCESS_KEY_ID "your-access-key-id"
SetEnv AWS_SECRET_ACCESS_KEY "your-secret-access-key"
SetEnv AWS_DEFAULT_REGION "us-west-2"