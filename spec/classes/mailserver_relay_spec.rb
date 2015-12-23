require 'spec_helper'

def_postfix_template = 'mailserver/postfix/postfix-relay-server.conf.erb'

def_absent            = false
def_disable           = false
def_relay             = true
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

describe 'mailserver::relay', :type => 'class' do

    context "Setup a webmail front-end" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it do
          should contain_class('postfix').with(
            'template' => def_postfix_template,
            'absent'   => def_absent,
            'disable'  => def_disable,
          )

          should have_mailserver__relay__auth_resource_count(0)
          should have_mailserver__relay__tls_resource_count(0)
          should_not contain_class('mailserver::relay::auth')
          should_not contain_class('mailserver::relay::tls')
        end
    end

    context "Setup a webmail front-end with relay_auth true " do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        let(:params) {{
            :relay_auth => relay_auth,
            :absent => def_absent,
            :relay_host => def_relay_host,
            :relay_auth_hosts => def_relay_auth_hosts,
            :disable => def_disable,
            :relay_auth_user => def_relay_auth_user,
            :relay_auth_passwd => def_relay_auth_passwd,
            :relay_tls_cert => def_relay_tls_cert,
            :relay_tls_key => def_relay_tls_key,
            :relay_tls_ca => def_relay_tls_ca,
            :relay_tls => relay_tls,
          }}
        it do
          should contain_class('postfix').with(
            'template' => def_postfix_template,
            'absent'   => def_absent,
            'disable'  => def_disable,
          )

          should contain_class('mailserver::relay::auth').with(
              'absent'            => def_absent,
              'disable'           => def_disable,
              'relay_host'        => def_relay_host,
              'relay_auth_user'   => def_relay_auth_user,
              'relay_auth_passwd' => def_relay_auth_passwd,
              'relay_auth_hosts'  => def_relay_auth_hosts,
              'relay_auth_pkgs'   => def_relay_auth_pkgs,
          )

          should contain_class('mailserver::relay::tls').with(
              'absent'            => def_absent,
              'disable'           => def_disable,
              'relay_host'        => def_relay_host,
              'relay_tls_cert'    => def_relay_tls_cert,
              'relay_tls_key'     => def_relay_tls_key,
              'relay_tls_ca'      => def_relay_tls_ca,
          )
        end
    end

end
