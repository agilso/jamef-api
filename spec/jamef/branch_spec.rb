require 'spec_helper'

RSpec.describe Jamef::Branch do
  
  context 'class' do
    
    context 'all method' do
      it 'returns an array containg all branches' do
        expect(Jamef::Branch.all).to be_an Array
        expect(Jamef::Branch.all).not_to be_empty
      end
    end
    
    context 'branch method' do
      
      subject {Jamef::Branch.branches}
      
      it {is_expected.to be_a(Hash)}
    
      it {is_expected.not_to be_empty}
    
    end
    
    context 'find method' do
    
      it 'raises if argument is not a String or Symbol' do
        expect{Jamef::Branch.find(2)}.to raise_error ArgumentError
      end
      it 'finds the branch by id' do
        expect(Jamef::Branch.find(:campinas)).to be_a Jamef::Branch
      end

      it 'if not found returns nil' do
        expect(Jamef::Branch.find(:unknown_chuck_norris_city)).to be_nil
      end
      
    end
  
  end
  
  let(:branch) { Jamef::Branch.new(id: :my_branch, code: '31', initials: 'MBR' , location: 'Any City - AS') }
  
  it 'has a valid "factory"' do
    expect(branch).to be_valid
  end
  
  [:id, :code, :initials, :location].each do |field|
    it "is invalid without #{field}" do
      branch.send("#{field}=",nil)
      expect(branch).not_to be_valid
    end
  end
  
end