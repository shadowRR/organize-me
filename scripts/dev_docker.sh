#!/bin/bash

docker run -d -p 5450:5432 --name organizeme-postgres
	-e "POSTGRES_USER=postgres"
	-e "POSTGRES_PASSWORD=password"
	-e "POSTGRES_DB=organizeme" postgres:10