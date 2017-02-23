#!/usr/bin/env bash

function man() {
  usage="Usage: $(basename "$0") [options... ]
Script to generate the right folder structure && docker-compose.yml files for JetBreans products instances.

    -h, --help    show this help text
    -t, --team    specify the team name
    -l, --tool    specify the tool (upsource, hub, youtrack)
    -p, --port    specify the port
    -n, --network specify the host network interface
    -v, --version specify the tool version
    -b, --build   specify the tool build

"
   echo "$usage"
}


if [ $# -eq 1 ]; then
   if [ $1 == "-h" ] || [ $1 == "--help" ]; then
       man
   fi
else
   while [[ $# -gt 1 ]]
   do
       key="$1"

       case $key in
          -h|--help)
            man
            exit 0
          ;;
          -t|--team)
            TEAM="$2"
            shift
          ;;
          -l|--tool)
            TOOL="$2"
            shift
          ;;
          -p|--port)
            PORT="$2"
            shift
          ;;
          -n|--network)
            NETWORK="$2"
            shift
          ;;
          -v|--version)
            VERSION="$2"
            shift
          ;;
          -b|--build)
            BUILD="$2"
            shift
          ;;
          *)
            # unknown option
          ;;
       esac
       shift # past argument or value
    done
fi


if [ -z "${TEAM}" ]; then
    echo "TEAM is unset";
    exit 1
fi
if [ -z "${TOOL}" ]; then
    echo "TOOL is unset";
    exit 1
fi
if [ -z "${VERSION}" ]; then
    echo "VERSION is unset";
    exit 1
fi
if [ -z "${BUILD}" ]; then
    echo "BUILD is unset";
    exit 1
fi
if [ -z "${NETWORK}" ]; then
    echo "NETWORK is unset";
    exit 1
fi



mkdir -p "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/docker
mkdir -p "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/volume/"${VERSION}"."${BUILD}"

echo directory "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker" created
echo directory "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"volume"/"${VERSION}"."${BUILD}" created
mkdir -p "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/volume/"${VERSION}"."${BUILD}"/{"backups","data","log","tmp"}

IP_HOST=$(ifconfig "${NETWORK}" | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')


case "${TOOL}" in
  hub|youtrack)
    DOCKER_COMPOSE_FILE_NAME="d_compose.yml"
  ;;
  upsource)
    DOCKER_COMPOSE_FILE_NAME="d_compose_upsource.yml"

    #Android home
    EXPORT_ANDROID_HOME=0

    if [ -z "${ANDROID_HOME}" ]; then
        echo "ANDROID_HOME not setted";
    else
        echo "ANDROID_HOME found.";
        while true; do
        read -p "Do you want to export expose the android SDK to Upsource? y/n " yn
        case $yn in
            [Yy]* ) EXPORT_ANDROID_HOME=1; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
done
    fi

  ;;
esac

sed -e s/=serviceName=/"${TOOL}"/g \
    -e s/=teamName=/"${TEAM}"/g \
    -e s/=serviceVersion=/"${VERSION}"/g \
    -e s/=serviceBuild=/"${BUILD}"/g \
    -e s/=portHost=/"${PORT}"/g \
    -e s/=portContainer=/"${PORT}"/g \
    -e s/=ipHost=/"${IP_HOST}"/g  <  dockerFileTemplates/"${DOCKER_COMPOSE_FILE_NAME}" > "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker/tmp-docker-compose.yml"

if [ ${EXPORT_ANDROID_HOME} -eq 1 ]; then
    sed -e s/=exportAndroidHome=/""/g \
        -e s/=hostAndroidHome=/"${ANDROID_HOME}"/g  <  "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker/tmp-docker-compose.yml" > "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker/docker-compose.yml"
else
    sed -e s/=exportAndroidHome=/"#"/g \
        -e s/=hostAndroidHome=/"null"/g  <  "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker/tmp-docker-compose.yml" > "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker/docker-compose.yml"
fi

rm "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker/tmp-docker-compose.yml"

cp dockerFileTemplates/"${TOOL}"/Dockerfile  "${TEAM}"/"${TOOL}"/"${VERSION}"."${BUILD}"/"docker/Dockerfile"

tree -L 3 -d "${TEAM}"

echo "now exec: 'sudo docker-compose -f ${TEAM}/${TOOL}/${VERSION}.${BUILD}/docker/docker-compose.yml up' "