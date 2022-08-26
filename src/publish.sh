VERSION="$1"
OVERRIDE="$2"
REPO_TOKEN="$3"

echo "VERSION=$VERSION"
echo "OVERRIDE=$OVERRIDE"

cd ".devcontainer"
ls -altr
docker login ghcr.io -u ${GITHUB_REF} -p ${REPO_TOKEN}

#VERSION=$VERSION docker-compose -f docker-compose.yml -f $OVERRIDE up --no-start --remove-orphans
IMAGES=$(docker inspect --format='{{.Image}}' $(docker ps -aq))

echo "IMAGES: $IMAGES"
exit 0
for IMAGE in $IMAGES; do
    echo "IMAGE: $IMAGE"
    
    NAME=$(basename ${GITHUB_REPOSITORY}).$(docker inspect --format '{{ index .Config.Labels "com.docker.compose.project" }}' $IMAGE)
    TAG="ghcr.io/${GITHUB_REPOSITORY}/$NAME:$VERSION"
    
    echo "Name=$NAME"
    #docker tag $IMAGE $TAG
    #docker push $TAG
done
