FROM bckmd/docker-ubuntu-supervisor:latest

ENV DEBIAN_FRONTEND noninteractive
ENV SCREEN_DIMENSIONS 1024x768x16
ENV DESKTOP_USERNAME vnc

RUN apt update -y
RUN apt upgrade -y
RUN apt install nano sudo x11vnc xvfb -y
RUN apt-get autoclean && apt-get autoremove

RUN useradd -ms /bin/bash ${DESKTOP_USERNAME}
RUN echo "${DESKTOP_USERNAME}:${DESKTOP_USERNAME}" | chpasswd
RUN adduser ${DESKTOP_USERNAME} sudo

RUN mkdir /home/${DESKTOP_USERNAME}/.vnc/
RUN x11vnc -storepasswd ${DESKTOP_USERNAME} /home/${DESKTOP_USERNAME}/.vnc/passwd
RUN chown -R ${DESKTOP_USERNAME}:${DESKTOP_USERNAME} /home/${DESKTOP_USERNAME}/.vnc
RUN chmod 0640 /home/${DESKTOP_USERNAME}/.vnc/passwd
RUN mkdir -p /etc/supervisor/conf.d/

EXPOSE 5900

COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisor.conf"]