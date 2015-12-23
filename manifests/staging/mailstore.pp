class mailserver::staging::mailstore(
        $mail_listen_address = $mailserver::staging::mail_listen_address,
        $imap_users = $mailserver::staging::imap_users,
    ) {
    # Use Dovecot as a local mailstore
    # $mail_listen_address = hiera('mail_listen_address', '127.0.0.1')
    # $imap_users = hiera('imap_users')
    class { 'dovecot':
      template    => "${module_name}/dovecot/dovecot-staging.conf.erb",
      config_file => '/etc/dovecot/dovecot.conf',
    }
    file { '/etc/dovecot/users':
        ensure  => 'file',
        content => template("${module_name}/dovecot/users-staging.erb"),
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        require => Class['dovecot'],
    }
}
