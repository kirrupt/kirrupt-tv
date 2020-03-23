FROM node:slim
RUN apt-get update \
    && apt-get install --no-install-recommends -y unzip xvfb libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sLo linux_amd64.zip https://github.com/linyows/go-retry/releases/download/v0.3.1/linux_amd64.zip && unzip linux_amd64.zip && mv retry /usr/local/bin
RUN cd /tmp \
    && curl -sLo /tmp/docker-19.03.8.tgz https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz \
    && tar xvfz docker-19.03.8.tgz \
    && mv docker/docker /usr/local/bin \
    && rm -rf /tmp/*
RUN npm install -g cypress
