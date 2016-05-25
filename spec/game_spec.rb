require './game.rb'

RSpec.describe Game do
  let(:game) { Game.new }

  describe '#win?' do
    context 'win' do
      it { expect(game.win?('++++')).to eq true }
    end
    context 'lose' do
      it { expect(game.win?('+++-')).to eq false }
      it { expect(game.attempts).to be < Game::ATTEMPTS }
    end
  end

  describe '#hint' do
    context 'hints available' do
      it { expect(game.hint('1234').size).to eq 1 }
    end

    context 'all hints used' do
      it { expect(game.hint('1234')).to eq nil }
    end
  end
end
