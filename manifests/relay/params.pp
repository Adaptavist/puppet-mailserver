# Class: mailserver::relay::params
#
# This class defines default parameters used by the main module class
# mailserver::relay Operating Systems differences in names and paths should be
# addressed here
#
# == Variables
#
# Refer to mailserver::relay class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#

class mailserver::relay::params {
    $relay_auth_pkgs = $::osfamily ? { # Default to RedHat/CentOS
        'Debian'    => ['libsasl2-2', 'sasl2-bin', 'libsasl2-modules'],
        default => ['cyrus-sasl-plain'],
    }
}
