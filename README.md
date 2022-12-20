# project

## Guide to running the application on local machine:

*If this guide is insufficient, check the [official documentation](https://guides.rubyonrails.org/getting_started.html)*

1. Make sure Ruby is installed
2. Run `gem install rails` to install Rails if needed (Use `rails --version` to check if Rails is installed. This app requires Rails 7 or higher)
3. Navigate to project/src/blog and run `bundle install` to install the necessary gems
4. 
    - If on Linux, run `sudo service redis-server start` to start up a redis server
    - If on Windows, follow [this guide](https://redis.io/docs/getting-started/installation/install-redis-on-windows/)
    - If on Mac, follow [this guide](https://redis.io/docs/getting-started/installation/install-redis-on-mac-os/)
    
5. Start up the application using `bin/rails server`, or `ruby bin\rails server` on Windows
6. The application should be hosted locally, and accessible from the port specified on the console