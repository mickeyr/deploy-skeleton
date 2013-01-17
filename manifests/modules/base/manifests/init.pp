class base($base_path) {

    exec { "update_apt":
        command => "apt-get update",
        user => "root",
    }

    package { [
            "git-core",
            "libpq-dev",
            "nginx",
            "postgresql",
            "python-dev",
            "python-virtualenv",
            "supervisor",
            "vim",
        ]:
        ensure => installed,
        require => Exec['update_apt'];
    }

    user { 'ubuntu':
        ensure => 'present',
        home => '/home/ubuntu',
        shell => '/bin/bash',
    }

    file {
        "/home/ubuntu/":
            ensure => 'directory',
            owner => 'ubuntu',
            require => User['ubuntu'];
        "base_path":
            path => "$base_path",
            ensure => 'directory',
            owner => 'ubuntu',
            require => User['ubuntu'];
        "/etc/nginx/sites-enabled/default":
            ensure => absent,
            require => Package['nginx'];
    }

    service {
        'nginx':
            enable => 'true',
            ensure => 'running',
            require => Package['nginx'];
        "postgresql":
            enable => "true",
            ensure => "running",
            require => Package["postgresql"];
        'supervisor':
            enable => 'true',
            ensure => 'running',
            require => Package['supervisor'];
        'ssh':
            enable => 'true',
            ensure => 'running';
    }
}
