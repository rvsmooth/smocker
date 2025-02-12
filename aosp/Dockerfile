FROM bitnami/minideb:bookworm

# Build-time variables
ARG userid=1000
ARG groupid=1000
ARG username=aosp
ARG fonts_dir=/tmp/fonts
ARG fonts_file=/tmp/fonts.zip
ARG starship_file=/tmp/starship.tar.gz
ARG starship_dir=/tmp/starship
ARG config=/home/${username}/.config
ARG fonts=/home/${username}/.local/share/fonts
ARG bullseye=/etc/apt/sources.list.d/bullseye.list

# Using separate RUNs here allows Docker to cache each update
RUN DEBIAN_FRONTEND="noninteractive" apt-get update

# Make sure the base image is up to date
RUN DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y

# Install apt-utils to make apt run more smoothly
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y apt-utils

# Install basic packages
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y sudo wget curl vim 

# Install the packages needed for the build
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y git-core gnupg flex bison build-essential \
	zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
	x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip \
	fontconfig libncurses5 procps rsync libssl-dev python-is-python3 less bc

# Download and verify repo
RUN gpg --recv-key 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo.asc | gpg --verify - /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

# User management
RUN groupadd -g $groupid $username \
 && useradd -m -s /bin/bash -u $userid -g $groupid $username \
 &&  echo "${username} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers \
 && chown -R ${username}:${username} /home/${username} \
 && mkdir /aosp && chown $userid:$groupid /aosp && chmod ug+s /aosp

# Install python2
RUN echo "deb http://deb.debian.org/debian bullseye main contrib non-free" | tee ${bullseye} \
&& apt-get update \
&& apt-get install -y python2.7 python-is-python2 python2 \
&& rm -rf ${bullseye}

# Eyecandy
RUN wget -qO ${starship_file} https://github.com/starship/starship/releases/download/v1.22.1/starship-x86_64-unknown-linux-gnu.tar.gz \
 && wget -qO ${fonts_file} https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip \
 && mkdir -p ${config} ${fonts_dir} ${starship_dir} ${fonts} \
 && tar -xzf ${starship_file} -C ${starship_dir} \
 && unzip -qo ${fonts_file} -d ${fonts_dir} \
 && cp ${fonts_dir}/* ${fonts} \
 && mv ${starship_dir}/* /usr/local/bin \
 && echo 'eval "$(starship init bash)"' >> /home/${username}/.bashrc \
 && starship preset nerd-font-symbols -o ${config}/starship.toml \
 && rm -rf ${starship_dir} ${starship_file} ${fonts_file} ${fonts_dir}

# Env
ENV KBUILD_BUILD_HOST smocker

WORKDIR /home/${username}
USER ${username}
CMD ["/bin/bash"]

# Git configs
RUN git config --global user.name Subhashis \
&& git config --global user.email riveeks.smooth@gmail.com \
&& git config --global color.ui false \
&& git config --global core.editor vim 
