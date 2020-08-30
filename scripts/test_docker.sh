#!/bin/bash

docker run -d -p 5451:5432 --name organizeme-postgres-test
	-e "POSTGRES_USER=postgres"
	-e "POSTGRES_PASSWORD=password"
	-e "POSTGRES_DB=organizeme-test" postgres:10