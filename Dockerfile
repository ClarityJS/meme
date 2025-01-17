FROM debian:bookworm-slim

WORKDIR /app
VOLUME /data

RUN apt update && \
    apt install --no-install-recommends -y\
    curl \
    git \
    libgl1 \
    fontconfig \
    gettext \
    ca-certificates \
    fonts-noto-color-emoji \
    python3 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean all

RUN curl -sSL https://install.python-poetry.org | python3 -

ENV TZ=Asia/Shanghai \
  PATH="${PATH}:/root/.local/bin"

ENV LOAD_BUILTIN_MEMES=true \
  MEME_DIRS="[\"/data/memes\"]" \
  MEME_DISABLED_LIST="[]" \
  GIF_MAX_SIZE=10.0 \
  GIF_MAX_FRAMES=100 \
  LOG_LEVEL="INFO" \
  BAIDU_TRANS_APPID="" \
  BAIDU_TRANS_APIKEY="" \
  HOST="0.0.0.0" \
  PORT="2233"

COPY ./data /data/memes
COPY ./docker/config.toml.template /app/config.toml.template

RUN git clone --depth 1 https://github.com/MemeCrafters/meme-generator ./meme && \
    cd meme && \
    poetry install && \
    mkdir -p /usr/share/fonts/meme &&\
    cp ./resources/fonts/* /usr/share/fonts/meme/ && \
    rm -f /usr/share/fontconfig/conf.avail/05-reset-dirs-sample.conf && \
    fc-cache -fv && \
    mkdir -p ~/.config/meme_generator && \
    rm -rf .git resources tools docker 


COPY ./docker/start.sh /app/start.sh
RUN chmod +x /app/start.sh

WORKDIR /app/meme
CMD ["/app/start.sh"]
