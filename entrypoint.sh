#!/bin/bash -e

sed -i -e "s/^rpc_address:.*/rpc_address: 0.0.0.0/" /etc/cassandra/cassandra.yaml
sed -i -e "s/^# broadcast_rpc_address:.*/broadcast_rpc_address: localhost/" /etc/cassandra/cassandra.yaml

service cassandra start && sleep 3
exec "$@"
