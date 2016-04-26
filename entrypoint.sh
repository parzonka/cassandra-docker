#!/bin/bash -e

# get container ip
IP=`hostname --ip-address | cut -f 1 -d ' '`

if [ -z "$CLUSTER_NAME" ]; then 
	sed -i -e "s/^# cluster_name:.*/cluster_name: Test Cluster/" /etc/cassandra/cassandra.yaml
else 
	sed -i -e "s/^# cluster_name:.*/cluster_name: $CLUSTER_NAME/" /etc/cassandra/cassandra.yaml
fi

# rpc_address is for client communication. we use a wildcard to listen on all available interfaces 
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" /etc/cassandra/cassandra.yaml

# broadcast container host address
sed -i -e "s/^# broadcast_rpc_address:.*/broadcast_rpc_address: $IP/" /etc/cassandra/cassandra.yaml

# listen_address is for communication between nodes (container host address)
sed -i -e "s/^listen_address.*/listen_address: $IP/" /etc/cassandra/cassandra.yaml

# The seeds act as the communication points. When a new node joins the cluster it contact the seeds and get the information about the ring and basics of other nodes.
# -e SEEDS="seed1.ip,seed2.ip,..."
if [ -z "$SEEDS" ] ; then 
	# no seeds => be your own seed
	sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$IP\"/" /etc/cassandra/cassandra.yaml
else 
	sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/" /etc/cassandra/cassandra.yaml
fi

# prevent errors when joining multiple nodes concurrently to empty cluster ("2 minute rule" should apply only when cluster has data)
if [ "$AUTO_BOOTSTRAP" = "false" ] ; then
	printf "\n#faster cluster initialization, do not set to false when joining an empty node to a cluster which has data\nauto_bootstrap=false\n" >> /etc/cassandra/cassandra.yaml 
fi

service cassandra start && sleep 3
exec "$@"
