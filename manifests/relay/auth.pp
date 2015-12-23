class mailserver::relay::auth (
    $absent            = $mailserver::relay::absent,
    $disable           = $mailserver::relay::disable,
    $relay_host        = $mailserver::relay::relay_host,
    $relay_auth_user   = $mailserver::relay::relay_auth_user,
    $relay_auth_passwd = $mailserver::relay::relay_auth_passwd,
    $relay_auth_hosts  = $mailserver::relay::relay_auth_hosts,
    $relay_auth_pkgs   = $mailserver::relay::relay_auth_pkgs,
) {
    # Install SASL package(s)
    $ensure_package = $absent ? {
        true  => 'purged',
        false => 'present',
    }
    package { $relay_auth_pkgs :
        ensure => $ensure_package,
    }

    $ensure_sasl_dir = $absent ? {
        true  => 'absent',
        false => 'directory',
    }
    file { '/etc/postfix/sasl':
        ensure => $ensure_sasl_dir,
        mode   => '0755',
        owner  => 'root',
        group  => 'root',
    }

    if ! $absent {
        $rawhosts = concat([ $relay_host ], $relay_auth_hosts)
        $shosts = suffix($rawhosts, ']')
        $relay_hosts = prefix($shosts, '[')
        $cred = "${relay_auth_user}:${relay_auth_passwd}"
        # Simple soultion of this is: [ $cred ] * size($relay_hosts)
        # But needs the future parser
        $creds =  split(inline_template("<%= ( [ @cred ] * @relay_hosts.length).join('::') %>"), '::')
        postfix::map {'sasl_auth':
            path => '/etc/postfix/sasl/saslpw',
            maps => zip($relay_hosts, $creds)
        }
    }
}
