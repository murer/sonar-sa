#!/bin/bash -xe

cmd_build() {
    docker build -t murer/sonar-sa:dev .
}

cmd_push() {
    docker tag murer/sonar-sa:dev murer/sonar-sa:latest
    docker push murer/sonar-sa:latest
}

cmd_sa() {
    #docker run --name sonar --rm -it sonarqube:lts # -Dsonar.login=admin -Dsonar.password=admin
    docker run --name sonar-sa --rm -p 9000:9000 -it murer/sonar-sa:dev entrypoint/sonar-sa.sh "$@"
}

cmd_server() {
    docker run --name sonar-sa --rm -it \
        -p 9000:9000 \
        murer/sonar-sa:dev \
        entrypoint/sonar-sa.sh server_only
}

cmd_main() {
    sonarsa_project="${1?'sonarsa_project'}"
    [[ -d "$sonarsa_project" ]]
    docker run --name sonar-sa --rm -it \
        -p 9000:9000 \
        -v "$sonarsa_project:/opt/sonar-sa/src" \
        murer/sonar-sa:dev \
        entrypoint/sonar-sa.sh main
}

cmd_sample_python() {
    cmd_main "$(pwd)/sample/sonar-sa-sample-python"
}

cmd_sample_local_java() {
    sonarsa_token="$(docker exec -i sonar-sa cat /tmp/sonarqa.token)"
    cd sample/sonar-sa-sample-java
    mvn clean install sonar:sonar \
        -Dsonar.projectKey=local \
        -Dsonar.host.url=http://localhost:9000 \
        "-Dsonar.login=$sonarsa_token"
    cd -
}

cmd_shell() {
    docker run --name sonar_shell --rm -it murer/sonar-sa:dev /bin/bash
}

cmd_exec() {
    docker exec -it sonar-sa /bin/bash
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
