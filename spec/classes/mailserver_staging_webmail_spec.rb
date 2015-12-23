require 'spec_helper'

def_apache_params_vdir = ''
apache_params_vdir = '/etc/apache/params'

describe 'mailserver::staging::webmail', :type => 'class' do

    context "Setup a webmail front-end" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it do
          should contain_package('squirrelmail').with_ensure('installed')

          should contain_class('apache').with( 
              'mpm_module' => 'prefork',
          )

          should contain_class('apache::mod::php')

          should contain_file('squirrelmail.conf').with(
              'path' => "#{def_apache_params_vdir}/squirrelmail.conf",
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
          ).that_requires('Package[httpd]')
          .that_requires('Package[squirrelmail]')
          .that_notifies('Service[httpd]')
          .with_content(/Alias \/webmail \/usr\/share\/squirrelmail/)
          .with_content(/<Directory \"\/usr\/share\/squirrelmail\/plugins\/squirrelspell\/modules\">/)
          .with_content(/Deny from all/)
          .with_content(/<\/Directory>/)
        end
    end

    context "Setup a webmail front-end, with params" do
        let(:params) {{
            :apache_params_vdir => apache_params_vdir,
          }}
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it do
          should contain_package('squirrelmail').with_ensure('installed')

          should contain_class('apache').with( 
              'mpm_module' => 'prefork',
          )

          should contain_class('apache::mod::php')

          should contain_file('squirrelmail.conf').with(
              'path' => "#{apache_params_vdir}/squirrelmail.conf",
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
          ).that_requires('Package[httpd]')
          .that_requires('Package[squirrelmail]')
          .that_notifies('Service[httpd]')
          .with_content(/Alias \/webmail \/usr\/share\/squirrelmail/)
          .with_content(/<Directory \"\/usr\/share\/squirrelmail\/plugins\/squirrelspell\/modules\">/)
          .with_content(/Deny from all/)
          .with_content(/<\/Directory>/)
        end
    end

end
