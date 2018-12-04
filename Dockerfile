FROM ubuntu:latest

RUN apt-get update && apt-get install -y sudo && apt-get install -y software-properties-common

RUN apt-get install -y git

WORKDIR /home

RUN git clone --recursive https://github.com/ruchern/dotfiles.git

RUN ls -la | grep dotfiles