class mailserver::staging(
        $email_domain = undef,
        $email_user_mapping = undef,
        $mail_listen_address = '127.0.0.1',
        $imap_users = [],
        $apache_params_vdir = $apache::params::vdir,
    ) {
    # Setup an MTA to recieve mail and deliver it all locally
    include mailserver::staging::mta
    # Setup a mailstore to recieve all mail
    include mailserver::staging::mailstore
    # Setup a webmail front-end
    include mailserver::staging::webmail
    # Pick and shift local mail too
    include mailclient::root_mail_forwarding
    # Forwarding of IMAP connections using haproxy
    include mailclient::mail_proxy
}
