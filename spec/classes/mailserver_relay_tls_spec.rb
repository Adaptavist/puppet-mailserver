require 'spec_helper'

def_postfix_template = 'mailserver/postfix/postfix-relay-server.conf.erb'

def_absent            = false
def_disable           = false
def_ensure_tls_dir    = 'directory'
def_relay_host        = 'relay'
def_relay_port        = 25
def_relay_tls         = false
def_relay_tls_cert    = '/etc/postfix/tls/smtp-client-cert.pem'
def_relay_tls_key     = '/etc/postfix/tls/smtp-client-key.key'
def_relay_tls_ca      = '/etc/postfix/tls/cacert.pem'
def_relay_auth        = false
def_relay_auth_user   = 'root@example.com'
def_relay_auth_passwd = 'ExamplePass'
def_relay_auth_hosts  = []
def_relay_auth_pkgs = ['libsasl2-2', 'sasl2-bin', 'libsasl2-modules']
relay_auth = true
relay_tls = true

describe 'mailserver::relay::tls', :type => 'class' do

    context "Setup postfix tls" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        let(:params) {{
            :relay_host => def_relay_host,
            :absent => def_absent,
          }}
        it do
    #       $ensure_tls_dir = $absent ? {
    #     true  => 'absent',
    #     false => 'directory',
    # }
        should contain_file('/etc/postfix/tls').with(
            'ensure'  => def_ensure_tls_dir,
            'mode'    => '0755',
            'owner'   => 'root',
            'group'   => 'root',
        )

        should contain_postfix__map('tls_relay').with(
            'path' => '/etc/postfix/tls/tls_sites',
            'maps' => [ "[#{def_relay_host}]", 'MUST' ]
        )
        end
    end

    context "Setup postfix tls, with absent true" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        let(:params) {{
            :relay_host => def_relay_host,
            :absent => true,
          }}
        it do
        should contain_file('/etc/postfix/tls').with(
            'ensure'  => 'absent',
            'mode'    => '0755',
            'owner'   => 'root',
            'group'   => 'root',
        )
        should_not contain_postfix__map('tls_relay')
      end
    end

end
