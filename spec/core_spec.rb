require './core.rb'

RSpec.describe Core do
  let(:core) { Core.new }

  cases = [
            ['1111', '1111', '++++'],
            ['1234', '4321', '----'],
            ['2363', '2366', '+++'],
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
      expect(core.secret_code.size).to eq 4
      core.secret_code.chars.each { |dig| expect(dig.to_i).to be_between(1, 6) }
    end
  end

  context '#verify_code' do
    it 'should raise exception if code size != 4' do
      expect { core.verify_code('12345') }.to raise_error RuntimeError
      expect { core.verify_code('123') }.to raise_error RuntimeError
    end

    it 'should raise exception if code is not number' do
      expect { core.verify_code('1a45') }.to raise_error RuntimeError
    end

    it 'should raise exception if code contains digit < 1 or > 6' do
      expect { core.verify_code('1230') }.to raise_error RuntimeError
      expect { core.verify_code('1734') }.to raise_error RuntimeError
    end

    cases.each do |x|
      it "should return #{x[2]} if secret_code == #{x[0]} and code == #{x[1]}" do
        core.secret_code = x[0]
        expect(core.verify_code(x[1])).to eq x[2]
      end
    end
  end
end
