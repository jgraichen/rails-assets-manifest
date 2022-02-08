# frozen_string_literal: true

RSpec.describe 'Plugin', type: :request do
  subject(:doc) do
    get '/'
    Nokogiri::HTML(response.body)
  end

  it 'contains the include tags with manifest resources' do
    doc.at('link#test1').tap do |node|
      expect(node).to be_present
      expect(node[:href]).to eq 'http://cdn.example.org/relroot/2b16adf6f756625a0194.css'
      expect(node[:integrity]).to eq 'sha384-/oreyvcV6U6htGZD0fDWR8/Txezke8KhD0QNgHb660hSaW7M+ZzxxuB4Vo+PuAC9'
    end

    doc.at('script#test2').tap do |node|
      expect(node).to be_present
      expect(node[:src]).to eq 'http://cdn.example.org/relroot/2b16adf6f756625a0194.js'
      expect(node[:integrity]).to eq 'sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B'
    end
  end

  if SPROCKETS
    it 'contains the passthrough resources from sprockets' do
      doc.at('link#test4').tap do |node|
        expect(node).to be_present
        expect(node[:href]).to eq 'http://cdn.example.org/relroot/assets/application-6ac3c3354847833f406a96850b1712fa3588191cae65a9f68b1d4c7c2e960139.css'
        expect(node[:integrity]).to be_blank
      end

      doc.at('script#test5').tap do |node|
        expect(node).to be_present
        expect(node[:src]).to eq 'http://cdn.example.org/relroot/assets/application-31d5c5a3accecb31cf2e14d71b9e2ff28609f3d45028700c7c4f067788b51d45.js'
        expect(node[:integrity]).to be_blank
      end
    end
  else
    it 'contains the passthrough resources from static assets' do
      doc.at('link#test4').tap do |node|
        expect(node).to be_present
        expect(node[:href]).to eq 'http://cdn.example.org/relroot/stylesheets/application.css'
        expect(node[:integrity]).to be_blank
      end

      doc.at('script#test5').tap do |node|
        expect(node).to be_present
        expect(node[:src]).to eq 'http://cdn.example.org/relroot/javascripts/application.js'
        expect(node[:integrity]).to be_blank
      end
    end
  end

  context 'with fully qualified entry URLs' do
    it 'returns the entry source' do
      doc.at('script#test3').tap do |node|
        expect(node).to be_present
        expect(node[:src]).to eq 'http://localhost:9002/ee3445.js'
        expect(node[:integrity]).to eq 'sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B'
      end
    end

    it 'does ignore asset host' do
      doc.at('script#test6').tap do |node|
        expect(node).to be_present
        expect(node[:src]).to eq 'http://localhost:9002/ee3445.js'
        expect(node[:integrity]).to eq 'sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B'
      end
    end

    it 'does ignore request protocol' do
      doc.at('script#test7').tap do |node|
        expect(node).to be_present
        expect(node[:src]).to eq 'http://localhost:9002/ee3445.js'
        expect(node[:integrity]).to eq 'sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B'
      end
    end
  end
end
