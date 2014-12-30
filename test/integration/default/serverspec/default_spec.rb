require 'spec_helper'

describe command('type lattice') do
  its(:exit_status) { should eq 0 }
end
