require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Console do

    describe '#initialize' do
      before { $stdin = StringIO.new("Martin\n") }
      after { $stdin = STDIN }

      it 'should output "Welcome to Codebreaker!" "Enter your name:"' do
        expect { subject }.to output("\"Welcome to Codebreaker app.\"\n\"Enter your name:\"\n").to_stdout
      end
      it 'name should be defined' do
        expect(subject.name).to eq 'Martin'
      end
      it 'code and game instances should be initialized' do
        expect(subject.code).not_to be_nil
        expect(subject.game).not_to be_nil
      end
    end
  end
end