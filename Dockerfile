FROM parzonka/java8


	curl -L --insecure https://debian.datastax.com/debian/repo_key | apt-key add - && \
	apt-get update && \
	apt-get install -y datastax-ddc && \
	apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && rm /etc/apt/sources.list.d/cassandra.sources.list

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]
