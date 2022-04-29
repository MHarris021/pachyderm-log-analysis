FROM ubuntu:impish-20220415

# Fix timezone issue
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
    && apt-get install -y jq \
    && jq --version

ADD src/scripts/* .
RUN chmod +x *.sh


