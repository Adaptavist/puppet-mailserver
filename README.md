# MailServer Module

## Overview

The **MailServer** module, contains one submodule called
**staging** which configures a Postfix MTA (with address rewriting),
Dovecot mailstore, and local webmail server along with invoking the
**MailClient** module.

This is designed to provide an email setup for staging environments
which require all mail rewritten to be redirected to the local
mailstore.

## Configuration

This module can be configured via Hiera via the following keys.

* `mailserver::staging::mta::email_user_mapping` - define the email
  rewriting used by Postfix

## Dependencies

* This module depends on the Postfix, HAProxy and Apache modules
