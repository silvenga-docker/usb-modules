FROM ubuntu:bionic

LABEL maintainer "Mark Lopez <m@silvenga.com>"

# Note that newer versions rely on kernel internal function.
ARG KERNEL_URL=https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.236.tar.xz

RUN set -xe \
    && apt-get update \
    && apt-get install -y wget make build-essential kmod rsync \
    && mkdir -p /source/linux \
    && wget ${KERNEL_URL} -O /source/linux.tar.xz \
    && tar xf /source/linux.tar.xz -C /source/linux --strip-components=1 \
    && mv /source/linux/drivers/usb /source/usb \
    && rm /source/linux.tar.xz \
    && rm /source/linux -r \
    && apt-get purge -y wget \
    && apt-get autoremove -y --purge \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY rootfs/ /

CMD ["/bin/bash", "/install-serial.sh"]
