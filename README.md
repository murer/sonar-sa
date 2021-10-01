# sonar-sa

## Getting Started

Run this in our source code directory.

It will create a directory ```.scannerwork``` that you should ```.gitignore```

```shell
docker run --name sonar-sa --rm -it \
    -p 9000:9000 \
    -v "$(pwd):/opt/sonar-sa/src" \
    murer/sonar-sa
```

Check the result on http://localhost:9000/

## Build image from source

```shell
docker build -t murer/sonar-sa:dev .
```

Check with our sample

```shell
docker run --name sonar-sa --rm -it \
    -p 9000:9000 \
    -v "$(pwd)/sample/python:/opt/sonar-sa/src" \
    murer/sonar-sa:dev
```