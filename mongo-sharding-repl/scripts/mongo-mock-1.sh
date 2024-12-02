#!/bin/bash

docker exec -i mongos_router mongosh --port 27018 <<EOF
sh.addShard( "shard1/shard1-1:27021,shard1-2:27022,shard1-3:27023")
sh.addShard( "shard2/shard2-1:27031,shard2-2:27032,shard2-3:27033")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
exit()
EOF

docker exec -i shard1-1 mongosh --port 27021 <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

docker exec -i shard2-1 mongosh --port 27031 <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF
