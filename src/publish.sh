VERSION="$1"
OVERRIDE="$2"
REPO_TOKEN="$3"

echo "VERSION=$VERSION"
echo "OVERRIDE=$OVERRIDE"

cd ".devcontainer"
ls -altr
docker login ghcr.io -u ${GITHUB_REF} -p ${REPO_TOKEN}

VERSION=$VERSION docker-compose -f docker-compose.yml -f $OVERRIDE up --no-start --remove-orphans
IMAGES=$(docker inspect --format='{{.Name}}' $(docker ps -aq))

echo "IMAGES: $IMAGES"
for IMAGE in $IMAGES; do
    NAME=${GITHUB_REPOSITORY}.$IMAGE
    ID=$(docker ps -aqf "NAME=$IMAGE")
    TAG="ghcr.io/${GITHUB_REPOSITORY}/$NAME:$VERSION"
    echo "ID=$ID"
    echo "Tag=$TAG"
    echo "NAME=$NAME"
    
    docker tag $NAME $TAG
    docker push $TAG
done
