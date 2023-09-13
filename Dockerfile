# Using Ubuntu 20.04 as the base image
FROM ubuntu:20.04 as base

# Copy the cleanup script and make it executable
COPY scripts/cleanup.sh /bin/cleanup
RUN chmod 7777 /bin/cleanup

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND noninteractive

# System update and Python 3.10 installation
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        software-properties-common \
        git \
        curl \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update -y \
    && apt-get install --no-install-recommends -y \
        python3.10 \
        python3.10-distutils \
    && curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10 \
    && add-apt-repository --remove ppa:deadsnakes/ppa \
    && apt-get remove -y software-properties-common \
    && cleanup

FROM base AS system

RUN python3.10 -m pip install \
      --no-cache-dir  \
      --upgrade pip -t /usr/lib/python3/dist-packages/ \
    && apt-get install --no-install-recommends -y \
        curl \
        vim \
        libglu1-mesa \
        libxcb-xinput0 \
        libxcb-xinerama0 \
        htop \
        ffmpeg \
        libnss3 \
        exiftool \
        neofetch \
    && cleanup


FROM system AS gui-system


RUN apt-get install --no-install-recommends -y \
        xfce4-panel \
        xfwm4 \
        xfdesktop4 \
        xfce4-settings \
        xfce4-whiskermenu-plugin \
        xfce4-session \
        terminator \
        xdg-utils \
        libxt6 \
        fonts-cascadia-code \
        xauth \
        curl \
        wget \
        dbus \
    && mkdir -p /usr/share/backgrounds/ \
    && rm -rfv /usr/share/backgrounds/* \
    && apt remove -y light-locker \
    && cleanup

FROM gui-system as desktop

# Goto https://www.nomachine.com/download/download&id=10 and change for the latest NOMACHINE_PACKAGE_NAME and MD5 shown in that link to get the latest version.
ARG PYCHARM_VERSION
ARG NOMACHINE_PACKAGE_NAME
ARG NOMACHINE_BUILD
ENV DEBIAN_FRONTEND=noninteractive

RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_BUILD}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
    && dpkg -i nomachine.deb && sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg \
    && wget -c "https://download-cf.jetbrains.com/python/pycharm-community-${PYCHARM_VERSION}.tar.gz" -O - | tar -xz -C /opt/ \
    && ln -s "/opt/pycharm-community-${PYCHARM_VERSION}/bin/pycharm.sh" /usr/bin/pycharm \
    && rm nomachine.deb \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get remove -y wget \
    && apt-get install -y sudo libxtst6 thunar firefox python3-pyqt5 at-spi2-core \
    && cp /opt/pycharm-community-${PYCHARM_VERSION}/bin/pycharm.png /usr/bin/pycharm.png \
    && cleanup

ADD scripts/nxserver.sh /
RUN chmod +x ./nxserver.sh
COPY ./launchers/ launchers/
CMD ["./nxserver.sh"]
