FROM fedora:34
MAINTAINER Marcelo Moreira de Mello <tchello.mello@gmail.com>
MAINTAINER Amar Huchchanavar <ahuchcha@redhat.com>
MAINTAINER Pablo N. Hess <phess@phess.org>


ENV PORT 8000

# create django-app user
RUN useradd django-app

# update and install dependencies
RUN dnf clean all && \
    dnf -y update && \
    dnf -y install python3 python3-devel python3-pip git \
    python3-virtualenv sqlite openssl-devel && \
    dnf clean all


# create directory and mount sources there
ADD start.sh requirements.txt mysslcerts /home/django-app/code/ 
RUN chmod +x /home/django-app/code/start.sh
ADD .bashrc /home/django-app/
RUN chown django-app:django-app -R /home/django-app

# set user
USER django-app
RUN /usr/bin/python3 -m virtualenv -p python3.9 /home/django-app/.virtualenv

# set workdir
WORKDIR /home/django-app/code

# export volume
VOLUME /home/django-app/code

# expose 8000 port
EXPOSE ${PORT}

# define command to start container
ENTRYPOINT ["/bin/bash", "/home/django-app/code/start.sh"]
