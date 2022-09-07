# syntax=docker/dockerfile:1.2

FROM jenkins/jenkins:2.268-alpine
USER root
RUN apk add --no-cache python3 && \
       python3 -m ensurepip && \
        pip3 install --upgrade pip setuptools && \
         if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
          if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
           rm -r /root/.cache

RUN apk add pkgconf
RUN apk add build-base
RUN apk add python3-dev libxml2-dev libxslt-dev postgresql-dev gcc python3-dev musl-dev libffi-dev openssl encfs gnupg openssh


USER jenkins
ENV PATH=/var/jenkins_home/.local/bin:${PATH}
ADD requirements.txt .
RUN pip3 install -r requirements.txt

ADD requirements.yaml .
RUN mkdir ~/.ssh/ ; chmod 0700 ~/.ssh; ssh-keyscan gitlab.com >  ~/.ssh/known_hosts
RUN --mount=type=ssh,mode=777 ansible-galaxy collection install -r requirements.yaml 
RUN --mount=type=ssh,mode=777 ansible-galaxy install -r requirements.yaml 

