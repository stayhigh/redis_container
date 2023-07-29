#!/bin/bash


# create and start a container
docker network create -d bridge redisnet && echo 'created network for redis'
docker run -d -p 6379:6379 --name myredis --network redisnet redis && echo 'started a redis container'

# load redis dataset test
docker exec -it myredis /bin/bash -c "apt update&& apt install -y git"
docker exec -it myredis /bin/bash -c 'git clone https://github.com/redis-developer/redis-datasets
cd redis-datasets/user-database'
docker exec -it myredis /bin/bash -c  \
'redis-cli -h localhost -p 6379 < ./import_users.redis'
docker exec -it myredis /bin/bash -c  \
'redis-cli -h localhost -p 6379 flushdb'

# stop container
docker stop myredis
