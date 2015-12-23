class mailserver::relay::tls (
    $absent            = $mailserver::relay::absent,
    $disable           = $mailserver::relay::disable,
    $relay_host        = $mailserver::relay::relay_host,
    $relay_tls_cert    = $mailserver::relay::relay_tls_cert,
    $relay_tls_key     = $mailserver::relay::relay_tls_key,
    $relay_tls_ca      = $mailserver::relay::relay_tls_ca,
) {
    $ensure_tls_dir = $absent ? {
        true  => 'absent',
        false => 'directory',
    }
    file { '/etc/postfix/tls':
        ensure => $ensure_tls_dir,
        mode   => '0755',
        owner  => 'root',
        group  => 'root',
    }

    if ! $absent {
          postfix::map {'tls_relay':
              path => '/etc/postfix/tls/tls_sites',
              maps => [
                    [ "[${relay_host}]", 'MUST' ],
                ]
          }
    }
}
