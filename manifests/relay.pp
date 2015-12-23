class mailserver::relay (
    $absent            = $mailserver::absent,
    $disable           = $mailserver::disable,
    $postfix_template  = "${module_name}/postfix/postfix-relay-server.conf.erb",
    $relay_host        = $mailserver::relay_host,
    $relay_port        = $mailserver::relay_port,
    $relay_tls         = $mailserver::relay_tls,
    $relay_tls_cert    = $mailserver::relay_tls_cert,
    $relay_tls_key     = $mailserver::relay_tls_key,
    $relay_tls_ca      = $mailserver::relay_tls_ca,
    $relay_auth        = $mailserver::relay_auth,
    $relay_auth_user   = $mailserver::relay_auth_user,
    $relay_auth_passwd = $mailserver::relay_auth_passwd,
    $relay_auth_hosts  = $mailserver::relay_auth_hosts,
    $relay_auth_pkgs   = $mailserver::relay::params::relay_auth_pkgs,
) inherits mailserver::relay::params {
    # TODO: If mailserver is defined this should depend on it and let it
    # TODO: Absent is not tested
    # TODO: Certs are just assumed to be put in-place by the user
    # configure postfix

    if $relay_auth {
        class { 'mailserver::relay::auth':
            absent            => $absent,
            disable           => $disable,
            relay_host        => $relay_host,
            relay_auth_user   => $relay_auth_user,
            relay_auth_passwd => $relay_auth_passwd,
            relay_auth_hosts  => $relay_auth_hosts,
            relay_auth_pkgs   => $relay_auth_pkgs,
            require           => Class['postfix'],
        }
    }
    if $relay_tls {
        class { 'mailserver::relay::tls':
            absent         => $absent,
            disable        => $disable,
            relay_host     => $relay_host,
            relay_tls_cert => $relay_tls_cert,
            relay_tls_ca   => $relay_tls_ca,
            require        => Class['postfix'],
        }
    }

    class { 'postfix':
        template => $postfix_template,
        absent   => $absent,
        disable  => $disable,
    }
}
