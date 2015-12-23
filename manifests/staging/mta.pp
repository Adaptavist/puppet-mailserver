class mailserver::staging::mta(
    $email_user_mapping = $mailserver::staging::email_user_mapping,
    $email_domain = $mailserver::staging::email_domain,
    ) {
    # Accept mail from specified sources
    # Deliver *all* mail locally
    # $email_domain = hiera('email_domain')
    class { 'postfix':
        template => "${module_name}/postfix/postfix-staging-server.conf.erb",
    }
    if $email_user_mapping {
        postfix::map { 'virtual-regexp':
            maps => $email_user_mapping
        }
    }
    postfix::map { 'virtual':
        maps => {},
    }
}
