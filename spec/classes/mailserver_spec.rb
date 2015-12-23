require 'spec_helper'

describe 'mailserver', :type => 'class' do

    context "Should include relay class based on type parameter" do
        let(:params) { {:type => 'relay'} }
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { should contain_mailserver__relay }
    end

    context "Should include staging class based on type parameter" do
        let(:params) { {:type => 'staging'} }
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { should contain_mailserver__staging }
    end

    context "Should include hub class based on type parameter" do
        let(:params) { {:type => 'hub'} }
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { expect { should contain_mailserver__hub }.to raise_error(Puppet::Error) }
    end

    context "Should fail for not specified type" do
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystemrelease => '5.0.9',
          # config for concat
          :concat_basedir => '/var/lib/puppet/concat',
        }}
        it { expect { should contain_mailserver__hub }.to raise_error(Puppet::Error) }
  end
end
