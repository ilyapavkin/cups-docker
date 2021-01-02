FROM jacobalberty/cups:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG SANED_SUBNET="172.17.0.0/16"
ARG HPLIP_VERSION=3.18.6

ENV PREFIX=/usr/local/docker
#COPY hplip-scan.sh ${PREFIX}/share/drivers/hplip-scan.sh

RUN /usr/local/docker/share/drivers/hplip-scan.sh

RUN apt-get update && apt-get install -y \
  xinetd \
  rsyslog \
  sane-utils

COPY saned /etc/xinetd.d/saned

RUN echo "RUN=yes" >> /etc/default/saned && \
  echo "${SANED_SUBNET}" >> /etc/sane.d/saned.conf

# Force install hp-plugin
RUN cd /tmp && \
  wget https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-${HPLIP_VERSION}-plugin.run && \
  wget https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-${HPLIP_VERSION}-plugin.run.asc && \
  chmod +x hplip-*.run && \
  yes | hp-plugin -p /tmp/hplip-${HPLIP_VERSION:-3.18.6}-plugin.run && \
  rm -f /tmp/*

# Add print:print user as admin
RUN apt-get install -y whois && useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print 
#&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Add saned in lp group to give access to usb
RUN usermod -aG lp saned

COPY services.sh ${PREFIX}/bin/services.sh
ENTRYPOINT ${PREFIX}/bin/services.sh

EXPOSE 6566
