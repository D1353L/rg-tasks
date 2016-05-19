require './codebreaker.rb'

RSpec.describe Codebreaker do
  let(:app) { Codebreaker.new }

  cases = [
            ['1111', '1111', '++++'],
            ['1234', '4321', '----'],
            ['1111', '1211', '+++'],
            ['1234', '2345', '---'],
            ['1234', '1536', '++'],
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

  context '#generate_code' do
    it 'should generate 4-digit code from 1 to 6' do
      expect(app.secret_code.size).to eq 4
      app.secret_code.chars.each { |dig| expect(dig.to_i).to be_between(1, 6) }
    end
  end

  context '#verify_code' do
    it 'should raise exception if code size != 4' do
      expect { app.verify_code('12345') }.to raise_error RuntimeError
    end

    it 'should raise exception if code is not number' do
      expect { app.verify_code('1a45') }.to raise_error RuntimeError
    end

    it 'should raise exception if code contains digit < 1' do
      expect { app.verify_code('1230') }.to raise_error RuntimeError
    end

    it 'should raise exception if code contains digit > 6' do
      expect { app.verify_code('1734') }.to raise_error RuntimeError
    end

    cases.each do |x|
      it "should return #{x[2]} if secret_code == #{x[0]} and code == #{x[1]}" do
        app.secret_code = x[0]
        expect(app.verify_code(x[1])).to eq x[2]
      end
    end
  end
end
