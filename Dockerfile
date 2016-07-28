FROM python:2.7
# Docker images can start off with nothing, but it's extremely
# common to pull in from a base image. In our case we're pulling
# in from the slim version of the official Python 2.7 image.
#
# Details about this image can be found here:
# https://hub.docker.com/_/python/
#
# Slim is pulling in from the official Debian Jessie image.
#
# You can tell it's using Debian Jessie by clicking the
# Dockerfile link next to the 2.7-slim bullet on the Docker hub.
#
# The Docker hub is the standard place for you to find official
# Docker images. Think of it like GitHub but for Docker images.
#
# The Flask application you cloned is compatible with Python 3.5
# so if you wanted to use 3.5 instead, you could replace 2.7.


MAINTAINER aileen novero  <novero.a@gmail.com>
# It is good practice to set a maintainer for all of your Docker
# images. It's not necessary but it's a good habit.

ENV INSTALL_PATH /take2
# The name of the application we're building is called Snake Eyes
# and while there is no standard on where your project should
# live inside of the Docker image, I like to put it in the root
# of the image and name it after the project.
#
# We don't even need to set the INSTALL_PATH variable, but I like
# to do it because we're going to be referencing it in a few spots
# later on in the Dockerfile.
#
# The variable could be named anything you want.

RUN mkdir -p $INSTALL_PATH
# This just creates the folder in the Docker image at the
# install path we defined above.

WORKDIR $INSTALL_PATH
# We're going to be executing a number of commands below, and
# having to CD into the /snakeeyes folder every time would be
# lame, so instead we can set the WORKDIR to be /snakeeyes.
#
# By doing this, Docker will be smart enough to execute all
# future commands from within this directory.


COPY requirements.txt requirements.txt
# This is going to copy in the requirements.txt file from our
# work station at a path relative to the Dockerfile to the
# /snakeeyes/requirements.txt path inside of the Docker image.
#
# It copies it to /snakeeyes because of the WORKDIR being set.
#
# We copy in our requirements.txt file before the main app
# because Docker is smart enough to cache "layers" when you build
# a Docker image.
#
# You see, each command we have in the Dockerfile is going to be
# ran and then saved as a separate layer. Docker is smart enough
# to only re-build pieces that change, in order from top to bottom.
#
# This is an advanced concept but it means that we'll be able to
# cache all of our pip packages so that if we make an application
# code change, it won't re-run pip install unless a package changed.



RUN pip install -r requirements.txt
# Like most Flask applications, we have a requirements.txt file
# to define all of our dependencies. So we install them as usual.
#
# We don't need to use virtualenv because our application is
# completely encapsulated in the Docker image. I know, it's awesome.

COPY . .
# This might look a bit alien but it's copying in everything from
# the current directory relative to the Dockerfile, over to the
# /snakeyes folder inside of the Docker image.
#
# We can get away with using the . for the second argument because
# this is how the unix command cp (copy) works. It stands for the
# current directory.

RUN pip install --editable .
# The Flask application has a Click based CLI component to it and
# this command will generate a standard egg-info folder.
#
# This has nothing to do with Docker, but we need to add it here
# to ensure our Docker image is ready to run our CLI commands.

CMD gunicorn -b 0.0.0.0:8000 --access-logfile - "take2.welcome_python3()"
# This is the command that's going to get ran by default if we run
# the Docker image without any arguments.
#
# In our case, it'll start up gunicorn on port 8000. In case you're
# new to Flask, the --access-log - means it will log all output to
