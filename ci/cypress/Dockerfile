FROM registry.gitlab.com/deanrock/debian-k3s-dind

RUN apt-get install -y curl software-properties-common
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y unzip nodejs xvfb libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 make
RUN npm install cypress
RUN wget https://github.com/linyows/go-retry/releases/download/v0.3.1/linux_amd64.zip && unzip linux_amd64.zip && mv retry /usr/local/bin
