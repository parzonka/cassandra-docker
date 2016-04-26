#!/bin/bash -e

sed -i -e "s/^rpc_address:.*/rpc_address: 0.0.0.0/" /etc/cassandra/cassandra.yaml
sed -i -e "s/^# broadcast_rpc_address:.*/broadcast_rpc_address: localhost/" /etc/cassandra/cassandra.yaml

if [ -z "$SEEDS" ]; then echo "No seeds set" ; else 
	sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/" /etc/cassandra/cassandra.yaml;
fi


if [ -z "$CLUSTER_NAME" ]; then echo "No cluster name set" ; else 
	sed -i -e "s/^# cluster_name:.*/cluster_name: $CLUSTER_NAME/" /etc/cassandra/cassandra.yaml
fi

service cassandra start && sleep 3
exec "$@"
