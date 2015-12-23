class mailserver (
  $type              = undef,
  $absent            = false,
  $disable           = false,
  $relay             = true,
  $relay_host        = 'relay',
  $relay_port        = 25,
  $relay_tls         = false,
  $relay_tls_cert    = '/etc/postfix/tls/smtp-client-cert.pem',
  $relay_tls_key     = '/etc/postfix/tls/smtp-client-key.key',
  $relay_tls_ca      = '/etc/postfix/tls/cacert.pem',
  $relay_auth        = false,
  $relay_auth_user   = 'root@example.com',
  $relay_auth_passwd = 'ExamplePass',
  $relay_auth_hosts  = [],
) {
    case $type {
        'staging': { include mailserver::staging }
        'relay':   { include mailserver::relay }
        # 'hub':     { include mailserver::hub } # NOT IMPLEMENTED
        default:   { fail("Unknown mailserver type \"${type}\"") }
    }
}
