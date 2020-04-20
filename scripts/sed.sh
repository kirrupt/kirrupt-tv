# YAML complains about `: ` in the command.
sed -i -e "s+build: ./tv/+image: registry.gitlab.com/kirrupt/kirrupt-tv-elixir/tv:$CI_COMMIT_SHA+g" docker-compose.yml
