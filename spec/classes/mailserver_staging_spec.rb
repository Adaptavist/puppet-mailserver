require 'spec_helper'

describe 'mailserver::staging', :type => 'class' do

    context "Should setup an MTA to recieve mail and deliver it all locally" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { 
          should contain_mailserver__staging__mta.with(
            'email_user_mapping' => nil,
            'email_domain' => nil,
          ) }
    end

    context "Should setup a mailstore to recieve all mail" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { should contain_mailserver__staging__mailstore.with(
            'mail_listen_address' => '127.0.0.1',
            'imap_users' => [],
          ) }
    end

    context "Should pick and shift local mail too" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { should contain_mailserver__staging__webmail.with(
            'apache_params_vdir' => nil,
          ) }
    end

    context "Should fail for not specified type" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { should contain_mailclient__root_mail_forwarding.with(
            'absent' => false,
            'root_mail_forwarding' => 'root@example.com'
          ) }
    end

    context "Should setup forwarding of IMAP connections using haproxy" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { should contain_mailclient__mail_proxy }
    end
end
