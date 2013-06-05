#!/bin/sh
exec /usr/bin/ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/<%= app_name %>_deploy_key_id_rsa "$@"