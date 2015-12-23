require 'spec_helper'

describe 'mailserver::staging::mailstore', :type => 'class' do

    context "Setup a mailstore to recieve all mail" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it do
          should contain_class('dovecot').with(
            'template' => 'mailserver/dovecot/dovecot-staging.conf.erb',
            'config_file' => '/etc/dovecot/dovecot.conf',
          )
          should contain_file('/etc/dovecot/users').with(
              'ensure'  => 'file',
              'mode'    => '0644',
              'owner'   => 'root',
              'group'   => 'root',
          ).that_requires('Class[dovecot]')
        end
    end

    context "Setup a mailstore to recieve all mail, with params" do
        let(:params) {{
            :mail_listen_address => '127.0.0.1',
            :imap_users => [],
          }}
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it do
          should contain_class('dovecot').with(
            'template' => 'mailserver/dovecot/dovecot-staging.conf.erb',
            'config_file' => '/etc/dovecot/dovecot.conf',
          )
          should contain_file('/etc/dovecot/users').with(
              'ensure'  => 'file',
              'mode'    => '0644',
              'owner'   => 'root',
              'group'   => 'root',
          ).that_requires('Class[dovecot]')
        end
    end

end
