FROM ubuntu:12.04

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer && \
    sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y wget apt-utils ia32-libs
RUN wget --no-check-certificate http://download.teamviewer.com/download/version_7x/teamviewer_linux_x64.deb
RUN dpkg -i teamviewer_linux_x64.deb || apt-get install -f -y && dpkg -i teamviewer_linux_x64.deb

USER developer
ENV HOME /home/developer
ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :0.0
VOLUME ["/tmp/.X11-unix"]
CMD /usr/bin/teamviewer
