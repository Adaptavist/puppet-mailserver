class mailserver::staging::webmail(
        $apache_params_vdir = $apache::params::vdir,
    ) {
    # Install squirrel mail and setup the appropriate apache config for it
    package { 'squirrelmail':
        ensure => 'installed',
    }

    class {'apache':
        mpm_module => 'prefork',
    }

    class {'apache::mod::php': }

    file { 'squirrelmail.conf':
        path    => "${apache_params_vdir}/squirrelmail.conf",
        content => template("${module_name}/vhosts/squirrelmail.conf.erb"),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['httpd', 'squirrelmail'],
        notify  => Service['httpd'],
    }
}
