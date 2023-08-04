#!/bin/bash -e

VERSION=$(versioningit)
CONTENT=$(echo $VERSION | base64)

ENDPOINT=vstavrinov/youtube-dl-service/contents
SHA="$(curl                                             \
    -H "Accept: application/vnd.github.v3+json"         \
    -H "Authorization: token $YOUTUBE_DL_SERVICE_TOKEN" \
    https://api.github.com/repos/$ENDPOINT/yt-dlp-version |
    awk -F\" '/"sha":/ {print $4}')"

curl -X PUT                                             \
    -H "Accept: application/vnd.github.v3+json"         \
    -H "Authorization: token $YOUTUBE_DL_SERVICE_TOKEN" \
    -d '{"message": "Update youtube-dl to '$VERSION'",
         "sha": "'$SHA'",
         "content": "'$CONTENT'"
      }'                                                \
    https://api.github.com/repos/$ENDPOINT/yt-dlp-version

ENDPOINT=vstavrinov/youtube-dl-service/actions/workflows/main.yml
COMMIT=$(git rev-parse --short $GITHUB_SHA)
curl -X POST                                            \
    -H "Accept: application/vnd.github.v3+json"         \
    -H "Authorization: token $YOUTUBE_DL_SERVICE_TOKEN" \
    -d '{"ref": "master",
         "inputs":
           {"youtube-dl": "'$COMMIT'"}
      }'                                                \
    https://api.github.com/repos/$ENDPOINT/dispatches
