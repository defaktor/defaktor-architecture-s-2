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

docker exec -i shard1-1 mongosh --port 27021 <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      {_id: 0, host: "shard1-1:27021"},
      {_id: 1, host: "shard1-2:27022"},
      {_id: 2, host: "shard1-3:27023"}
    ]
  }
)
exit()
EOF

docker exec -i shard2-1 mongosh --port 27031 <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
     {_id: 0, host: "shard2-1:27031"},
     {_id: 1, host: "shard2-2:27032"},
     {_id: 2, host: "shard2-3:27033"}
    ]
  }
)
exit()
EOF
