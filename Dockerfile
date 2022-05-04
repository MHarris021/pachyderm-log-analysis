# Base image used is the latest version of the ubuntu base image
# alpine linux base image might be used for smalller size, but wasn't sure about available packages and differences between ubuntu and alpine
FROM ubuntu:impish-20220415

# Fix timezone issue
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages
RUN apt-get update \
    && apt-get install -y jq \
    && jq --version

# add scripts to image
ADD src/scripts/* /

# make scripts executable
RUN chmod +x *.sh


