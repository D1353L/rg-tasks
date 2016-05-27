require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Code do
    let(:code) { Code.new }

    cases = [
        ['1111', '1111', '++++'],
        ['1234', '4321', '----'],
        ['2363', '2366', '+++'],
        ['1234', '2345', '---'],
        ['3635', '3333', '++'],
        ['1234', '5513', '--'],
        ['1234', '5535', '+'],
        ['1234', '5525', '-'],
        ['1234', '4213', '+---'],
        ['1234', '2134', '++--'],
        ['1234', '5134', '++-'],
        ['1234', '5213', '+--'],
        ['1234', '1546', '+-'],
        ['1234', '5555', '']
    ]

    describe '#generate_code' do
      context 'generates 4-digit code' do
        it { expect(code.secret_code.size).to eq 4 }
      end

      context 'code digits are from 1 to 6' do
        it { expect(code.secret_code).to match(/[1-6]{4}/) }
      end
    end

    describe '#verify_code' do
      context 'code size != 4' do
        it { expect { code.verify('12345') }.to raise_error RuntimeError }
        it { expect { code.verify('123') }.to raise_error RuntimeError }
      end

      context 'code is not a number' do
        it { expect { code.verify('1a45') }.to raise_error RuntimeError }
      end

      context 'code contains digit < 1 or > 6' do
        it { expect { code.verify('1230') }.to raise_error RuntimeError }
        it { expect { code.verify('1734') }.to raise_error RuntimeError }
      end

      cases.each do |x|
        it "should return #{x[2]} if secret_code == #{x[0]} and code == #{x[1]}" do
          code.instance_variable_set(:@secret_code, x[0])
          expect(code.verify(x[1])).to eq x[2]
        end
      end
    end
  end
end
