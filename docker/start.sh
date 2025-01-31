#!/bin/sh

mkdir -p /data/memes
mv /app/default_memes/* /data/memes/ 2>/dev/null || true

envsubst < /app/config.toml.template > ~/.config/meme_generator/config.toml

cd /app/meme
exec poetry run meme start
