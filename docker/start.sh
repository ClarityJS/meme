#! /bin/sh

envsubst < /app/config.toml.template > ~/.config/meme_generator/config.toml

cd /app/meme
exec poetry run meme start