#!/bin/bash

docker exec -i configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
)
exit()
EOF

docker exec -i shard1 mongosh --port 27018 <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1:27018" },
     // { _id : 1, host : "shard2:27019" }
    ]
  }
)
exit()
EOF

docker exec -i shard2 mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
     // { _id : 0, host : "shard1:27018" },
      { _id : 1, host : "shard2:27019" }
    ]
  }
)
exit()
EOF
