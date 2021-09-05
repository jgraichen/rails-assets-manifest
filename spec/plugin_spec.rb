# frozen_string_literal: true

RSpec.describe 'Plugin', type: :request do
  subject(:doc) do
    get '/'
    Nokogiri::HTML(response.body)
  end

  it 'contains the include tags with manifest resources' do
    doc.at('link#test1').tap do |node|
      expect(node).to be_present
      expect(node[:href]).to eq '2b16adf6f756625a0194.css'
      expect(node[:integrity]).to eq 'sha384-/oreyvcV6U6htGZD0fDWR8/Txezke8KhD0QNgHb660hSaW7M+ZzxxuB4Vo+PuAC9'
    end

    doc.at('script#test2').tap do |node|
      expect(node).to be_present
      expect(node[:src]).to eq '2b16adf6f756625a0194.js'
      expect(node[:integrity]).to eq 'sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B'
    end
  end

  it 'contains the script tag with fully qualified resource URL' do
    doc.at('script#test3').tap do |node|
      expect(node).to be_present
      expect(node[:src]).to eq 'http://localhost:9002/ee3445.js'
      expect(node[:integrity]).to eq 'sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B'
    end
  end

  it 'contains the passthrough resources from sprockets' do
    doc.at('link#test4').tap do |node|
      expect(node).to be_present
      expect(node[:href]).to eq '/assets/application-6ac3c3354847833f406a96850b1712fa3588191cae65a9f68b1d4c7c2e960139.css'
      expect(node[:integrity]).to be_blank
    end

    doc.at('script#test5').tap do |node|
      expect(node).to be_present
      expect(node[:src]).to eq '/assets/application-31d5c5a3accecb31cf2e14d71b9e2ff28609f3d45028700c7c4f067788b51d45.js'
      expect(node[:integrity]).to be_blank
    end
  end
end
