require 'spec_helper'

describe 'mailserver::staging::mta', :type => 'class' do

    context "Should setup an MTA to recieve mail and deliver it all locally" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it do
          should contain_class('postfix')
          .with(
            'template' => 'mailserver/postfix/postfix-staging-server.conf.erb',
          )
          should contain_postfix__map('virtual').with(
              'maps' => {},
          )
        end
    end

    context "Should setup an MTA to recieve mail and deliver it all locally, with params" do
        let(:params) {{
            :email_user_mapping => {},
            :email_domain => 'example.com',
          }}
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it do
          should contain_postfix__map('virtual-regexp').with(
              'maps' => {},
          )
          should contain_postfix__map('virtual').with(
              'maps' => {},
          )
        end
    end

end
