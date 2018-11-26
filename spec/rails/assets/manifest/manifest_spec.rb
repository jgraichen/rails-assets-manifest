# frozen_string_literal: true

require 'tempfile'

RSpec.describe Rails::Assets::Manifest::Manifest do
  subject(:manifest) { described_class.new(path) }

  let(:tmpfile) { Tempfile.new 'manifest' }
  let(:path) { tmpfile.path }

  after { tmpfile.unlink }

  describe '#lookup' do
    subject(:entry) { manifest.lookup('app.js') }

    before do
      tmpfile.write JSON.dump('app.js': {src: 'app-digest.js'})
      tmpfile.flush
    end

    it 'returns manifest entry' do
      expect(entry).to be_a Rails::Assets::Manifest::Manifest::Entry
      expect(entry.src).to eq 'app-digest.js'
    end

    context 'with unknown name' do
      subject(:entry) { manifest.lookup('missing.js') }

      it { is_expected.to be nil }
    end
  end

  describe '#lookup!' do
    subject(:entry) { manifest.lookup!('app.js') }

    before do
      tmpfile.write JSON.dump('app.js': {src: 'app-digest.js'})
      tmpfile.flush
    end

    it 'returns manifest entry' do
      expect(entry).to be_a Rails::Assets::Manifest::Manifest::Entry
      expect(entry.src).to eq 'app-digest.js'
    end

    context 'with unknown name' do
      subject(:entry) { manifest.lookup!('missing.js') }

      it { expect { entry }.to raise_error(::Rails::Assets::Manifest::EntryMissing) }
    end
  end
end
