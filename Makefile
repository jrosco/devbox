NAME ?= devbox
# TODO: If you forked this repo you might want to change below var :) 
DOCKER_NAME ?= jr0sco/docker-devbox
DOCKER_TAG = $(shell git describe --tags)
LOGIN_AS ?= devbox
IMAGE_ID := $(shell docker ps -f name=$(NAME) -q -a)
LOCAL_DIR ?= `pwd`
DOCKER_DIR ?= /opt
HOST_HOME = $(shell echo $$HOME)
DOTFILES_DIR = $(HOST_HOME)/.dotfiles
DOCKER_HOME ?= /home/$(LOGIN_AS)
DOT_AWS=$(HOST_HOME)/.aws
DOT_SSH=$(HOST_HOME)/.ssh

.DEFAULT_GOAL := all

run:
	docker $@ -d --rm -it --name=$(NAME) \
		--mount type=bind,source=$(DOTFILES_DIR),target=$(DOCKER_HOME)/.dotfiles \
		--mount type=bind,source=$(HOST_HOME),target=$(DOCKER_HOME)/host \
		--mount type=bind,source=$(LOCAL_DIR),target=$(DOCKER_DIR) \
		--mount type=bind,source=$(DOT_AWS),target=$(DOCKER_HOME)/.aws \
		--mount type=bind,source=$(DOT_SSH),target=$(DOCKER_HOME)/.ssh \
		$(DOCKER_NAME):$(DOCKER_TAG)

build:
	docker $@ -t $(DOCKER_NAME):$(DOCKER_TAG) .

logon:
	docker exec -it $(NAME) su $(LOGIN_AS)

pull:
	docker pull $(DOCKER_NAME):$(DOCKER_TAG)

push:
	docker $@ $(DOCKER_NAME):$(DOCKER_TAG)

destory:
	docker rm $(NAME) -f

stop: 
	docker stop $(NAME)

list-running:
	docker ps -f name=$(NAME)
	docker top $(NAME)

all: build run logon

rmi:
	docker $@ `docker images $(DOCKER_NAME) -q` -f 

clean: stop destory 
