require 'spec_helper'

def_postfix_template = 'mailserver/postfix/postfix-relay-server.conf.erb'

def_absent            = false
def_disable           = false
def_relay             = true
def_relay_host        = 'relay'
def_relay_port        = 25
def_relay_auth_user   = 'root@example.com'
def_relay_auth_passwd = 'ExamplePass'
def_relay_auth_hosts  = []
def_relay_auth_pkgs = ['libsasl2-2', 'sasl2-bin', 'libsasl2-modules']
relay_auth_pkgs = ['cyrus-sasl-plain']
relay_auth = true
relay_tls = true

describe 'mailserver::relay::auth', :type => 'class' do

    context "Setup a webmail front-end with absent set to false and default params" do
        let(:facts) { {
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        } }
        let(:params) {{
            :absent => def_absent,
            :relay_host => def_relay_host,
            :relay_auth_hosts => def_relay_auth_hosts,
          }}
        it do
          should contain_file('/etc/postfix/sasl').with(
              'ensure'  => 'directory',
              'mode'    => '0755',
              'owner'   => 'root',
              'group'   => 'root',
          )
          should contain_postfix__map('sasl_auth').with(
            'path' => '/etc/postfix/sasl/saslpw',
            'maps' => ["[relay]", ":"],
            )
        end
    end

    context "Setup a webmail front-end with absent set to true and default params" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        let(:params) {{
            :absent => true,
          }}
        it do
          should contain_file('/etc/postfix/sasl').with(
              'ensure'  => 'absent',
              'mode'    => '0755',
              'owner'   => 'root',
              'group'   => 'root',
          )
          should_not contain_postfix__map('sasl_auth')
        end
    end

    context "Setup a webmail front-end with absent set to false and setup params" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        let(:params) {{
            :absent => def_absent,
            :relay_host => def_relay_host,
            :relay_auth_hosts => def_relay_auth_hosts,
            :relay_auth_user => def_relay_auth_user,
            :relay_auth_passwd => def_relay_auth_passwd,
          }}
        it do
          should contain_file('/etc/postfix/sasl').with(
              'ensure'  => 'directory',
              'mode'    => '0755',
              'owner'   => 'root',
              'group'   => 'root',
          )
          should contain_postfix__map('sasl_auth').with(
            'path' => '/etc/postfix/sasl/saslpw',
            'maps' => ["[relay]", "root@example.com:ExamplePass"],
            )
        end
    end

    context "Setup correctly packages passed param when absent is true" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        let(:params) {{
            :absent => def_absent,
            :relay_host => def_relay_host,
            :relay_auth_hosts => def_relay_auth_hosts,
            :relay_auth_user => def_relay_auth_user,
            :relay_auth_passwd => def_relay_auth_passwd,
            :relay_auth_pkgs => def_relay_auth_pkgs,
          }}
        it do
          def_relay_auth_pkgs.each do |package|
            should contain_package(package).with(
              'ensure' => 'present',
            )
          end
        end
    end

    context "Setup correctly packages passed param when absent is false" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        let(:params) {{
            :absent => true,
            :relay_host => def_relay_host,
            :relay_auth_hosts => def_relay_auth_hosts,
            :relay_auth_user => def_relay_auth_user,
            :relay_auth_passwd => def_relay_auth_passwd,
            :relay_auth_pkgs => def_relay_auth_pkgs,
          }}
        it do
          def_relay_auth_pkgs.each do |package|
            should contain_package(package).with(
              'ensure' => 'purged',
            )
          end
        end
    end
end
