FROM archlinux/archlinux:base-devel

# RUN pacman -Syu --needed --noconfirm git

# Set the working directory to /app
WORKDIR /app

# COPY . .
COPY ./app /app

RUN pacman -Syu --noconfirm --disable-sandbox \
    && pacman -S --noconfirm --disable-sandbox \
        ffmpeg \
        mkvtoolnix-cli \
        sqlite3 \
        vapoursynth-plugin-mvtools \
        cronie \
        sudo \
        git

RUN touch /app/av1an.log

RUN mv /app/cron.sh /usr/bin/cron.sh
# ADD ./app/cron.sh /usr/bin/cron.sh
RUN chmod +x /usr/bin/cron.sh

RUN chmod +x /app/start.sh

# makepkg user and workdir
ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  # Clean up
  && rm -rf .cache yay

# RUN yay -Yg av1an-git svt-av1-git vapoursynth-git vapoursynth-plugin-lsmashsource-git
RUN yay -S av1an-git vapoursynth-plugin-lsmashsource-git --noconfirm --useask --askyesremovemake --answerclean All --answerdiff None --answeredit All
# RUN yay -S svt-av1-git vapoursynth-plugin-lsmashsource-git --noconfirm --askyesremovemake --answerclean All --answerdiff None --answeredit All

USER root
WORKDIR /app

# COPY ./app/media.example.env media.env

# Run cron.sh when the container launches
CMD ["/bin/sh", "/usr/bin/cron.sh"]