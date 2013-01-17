sed -i s/synchronous_standby_names/#synchronous_standby_names/ /etc/postgresql/9.1/main/postgresql.conf
service postgresql restart
su - postgres -c "psql -c \"SELECT pg_start_backup('backup', true)\" ; rsync -av --exclude postmaster.pid --exclude pg_xlog /var/lib/postgresql/9.1/main/ slave:/var/lib/postgresql/9.1/main/ ; psql -c \"SELECT pg_stop_backup()\""
sed -i s/#synchronous_standby_names/synchronous_standby_names/ /etc/postgresql/9.1/main/postgresql.conf
service postgresql restart