Deploy Skeleton
===============

Uses Fabric, Puppet and Vagrant to effortlessly deploy an Ubuntu/Nginx/Supervisord/PostgreSQL/uWSGI/Django webapp.

Getting Started
---------------

Edit ``site.pp`` and specify your app specific parameters, i.e.::

    $base_path = "<base path where you want to store your app, i.e. /var/webapps>"
    $app_name = "<name of your webapp i.e. jabomly>"
    $app_module_name = "<name of the Python module containing your Django WSGI module, i.e. jabomly"
    $repo_url = "<git url of a repo containing your Django project/app, i.e. git@github.com:jodo/jabomly.git>"
    $db_name = "<database name to use for your app>"
    $db_username = "<database username to use for your app>"
    $db_password = "<database password to use for your app>"

Then generate a deploy key and add it to your repo's deploy keys as per usual::

    $ ssh-keygen -t rsa -C "your@dress.com" -f manifests/modules/webworker/files/deploy_key_id_rsa

Local Testing
-------------
With configuration and deploy key setup done you can test a deploy locally using `Vagrant <http://www.vagrantup.com>`_::

    $ vagrant up
    $ vagrant ssh
    $ sudo su ubuntu
    $ cd <path to your webapp, i.e. /var/webapps/jabomly>
    $ . ve/bin/activate
    $ ./<app_module_name>/manage.py syncdb --migrate
    $ ./<app_module_name>/manage.py collectstatic

After which your app should be live on `http://localhost:4501 <http://localhost:4501>`_.

Remote Deploying
----------------
To deploy remotely you need to add some more configuration in ``fabfile.py``, i.e.::

    HOST = "<hostname or IP of remote machine to deploy to, i.e. 178.26.131.86>"
    REPO_HTTPS_URL = "<https url of a repo containing this deploy repo with your sepcific configurations, i.e. https://jodo@github.org/jodo/jabomly.git>"
    APP_PATH = "<path where you want to store your app, i.e. /var/webapps/jabomly>"
    APP_MODULE_NAME = "<name of the Python module containing your Django WSGI module, i.e. jabomly"

After which you can issue an initial provision using::

    $ fab provision

issue a service reload using::

    $ fab reload

and release new code using::

    $ fab release