#!/usr/bin/env bash
CIRCLE_TOKEN="$(cat local.token)"
LATEST_COMMIT="$(git log -1 --pretty=format:"%H")"
REPO_REF="$(git remote v | grep push | awk '{print $2}' | sed 's/git\@//' | sed 's/:/\//' | sed 's/\.git//' | sed 's/\.com//')"
BRANCH_NAME="$(git branch | grep '*' | awk '{print $2}')"
curl \
   --silent \
   --user "${CIRCLE_TOKEN}": \
   --request POST \
   --form revision="${LATEST_COMMIT}" \
   --form config=@config.yml \
   --remote-name \
   --form notify=false \
      "https://circleci.com/api/v1.1/project/${REPO_REF}/tree/${BRANCH_NAME}"
rm LAST_LOCAL_BUILD.json
mv "${BRANCH_NAME}" LAST_LOCAL_BUILD.json
echo
cat LAST_LOCAL_BUILD.json | jq -r '.messages[].message' | sed -e 's/<[a-zA-Z\/][^>]*>//g'
