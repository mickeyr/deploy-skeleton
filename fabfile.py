import os

from fabric.api import cd, hosts, prefix, run, sudo

HOST = "<hostname or IP of remote machine to deploy to, i.e. 178.26.131.86>"
APP_PATH = "<path where you want to store your app, i.e. /var/webapps/jabomly>"
APP_MODULE_NAME = "<name of the Python module containing your Django WSGI module, i.e. jabomly"
REPO_HTTPS_URL = "<https url of a repo containing this deploy repo with your sepcific configurations, i.e. https://jodo@github.org/jodo/jabomly.git>"


@hosts(HOST,)
def provision():
    sudo('apt-get update')
    sudo('apt-get install -y git-core puppet')
    run('rm -rf ~/%s' % APP_MODULE_NAME)
    run('git clone %s %s' % (REPO_HTTPS_URL, APP_MODULE_NAME))
    with cd(APP_MODULE_NAME):
        sudo('puppet apply ./manifests/site.pp --modulepath ./manifests/modules')
    release()
    run('rm -rf ~/%s' % APP_MODULE_NAME)


@hosts(HOST,)
def reload():
    sudo('service nginx reload')
    sudo('supervisorctl reload')


@hosts(HOST,)
def release():
    with cd(APP_PATH):
        sudo('/bin/sh -c "export GIT_SSH=/home/ubuntu/%s_git.sh && git pull origin master"' % (APP_MODULE_NAME), user='ubuntu')
        with prefix('. ve/bin/activate'):
            sudo('./%s/manage.py syncdb --migrate' % APP_MODULE_NAME, user="ubuntu")
            sudo('./%s/manage.py collectstatic --noinput' % APP_MODULE_NAME, user="ubuntu")
    reload()
