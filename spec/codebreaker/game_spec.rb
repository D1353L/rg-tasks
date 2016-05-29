require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Game do

    describe '#win?' do
      context 'win' do
        it { expect(subject.win?('++++')).to eq true }
      end
      context 'lose' do
        it 'return false and attempts number is decremented' do
          expect(subject.win?('+++-')).to eq false
          expect(subject.attempts).to eq Game::ATTEMPTS - 1
        end
      end
    end

    describe '#hint' do
      context 'hints available' do
        it 'return hint and hints number is decremented' do
          expect(subject.hint('1234').size).to eq 1
          expect(subject.hints).to eq Game::HINTS - 1
        end
      end

      context 'all hints used' do
        it 'should return nil' do
          subject.instance_variable_set(:@hints, 0)
          expect(subject.hint('1234')).to eq nil
        end
      end
    end
  end
end