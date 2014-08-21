#!/usr/bin/env bash

source settings 

echo "================= changing locale postgres =================="
sudo -u postgres pg_dumpall > /tmp/postgres.sql 
sudo -u postgres pg_dropcluster --stop 9.3 main
sudo -u postgres pg_createcluster --locale en_US.UTF-8 --start 9.3 main
sudo -u postgres psql -f /tmp/postgres.sql

# create root user
echo "================= creating root user =================="
sudo -u postgres createuser --superuser root
sudo -u postgres createdb root

# Edit the following to change the name of the database user that will be created:
# both are sourced from the settings file
# APP_DB_USER=
# APP_DB_PASS=

# Edit the following to change the name of the database that is created (defaults to the user name)
APP_DB_NAME=$APP_DB_USER

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=9.3

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port (default: 15432)"
  echo "  Host: localhost"
  echo "  Port: 15432"
  echo "  Database: $APP_DB_NAME"
  echo "  Username: $APP_DB_USER"
  echo "  Password: $APP_DB_PASS"
  echo ""
  echo "Admin access to postgres user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost $APP_DB_NAME"
  echo ""
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:15432/$APP_DB_NAME"
  echo ""
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 15432 $APP_DB_NAME"
}

# Update package list and upgrade all packages
# has already happened in deb-deps.sh
# apt-get update
# apt-get -y upgrade
# apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

# Edit postgresql.conf to change listen address to '*':
#sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Append to pg_hba.conf to add password auth:
#echo "host    all             all             all                     md5" >> "$PG_HBA"

# Restart so that all new config is loaded:
#sudo service postgresql restart

#cat << EOF | su - postgres -c psql
#-- Create the database user:
#CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

#-- Create the database:
#CREATE DATABASE $APP_DB_NAME WITH OWNER $APP_DB_USER;
#EOF

#echo "Successfully created PostgreSQL dev virtual machine."
#echo ""
#print_db_usage
