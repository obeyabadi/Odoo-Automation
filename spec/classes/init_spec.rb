require 'spec_helper'
describe 'odoo11' do
  context 'with default values for all parameters' do
    it { should contain_class('odoo11') }
  end
end
