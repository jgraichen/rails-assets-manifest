# frozen_string_literal: true

require 'tempfile'
require 'pathname'

RSpec.describe Rails::Assets::Manifest::Manifest do
  subject(:manifest) { described_class.new(files: files) }

  let(:tmp) { Pathname.new(Dir.mktmpdir('manifest')) }
  let(:tmpfile) { tmp.join('manifest.json').open('w') }
  let(:files) { tmp.join('*.json') }

  after { tmp.rmtree }

  let(:payload) do
    {'app.js': 'app-digest.js'}
  end

  before do
    tmp.join('manifest.json').open('w') {|f| f.write JSON.generate(payload) }
  end

  context 'with multiple files in glob pattern' do
    before do
      tmp.join('second-manifest.json').open('w') do |file|
        file.write JSON.generate('app2.js': 'app2-digest.js')
      end
    end

    it 'includes entries from both files' do
      expect(manifest).to be_key 'app.js'
      expect(manifest).to be_key 'app2.js'
    end

    context 'with multiple patterns/files' do
      let(:files) { [tmp.join('manifest.json'), tmp.join('second*.json')] }

      it 'includes entries from both files' do
        expect(manifest).to be_key 'app.js'
        expect(manifest).to be_key 'app2.js'
      end
    end
  end

  context 'with invalid entry' do
    let(:payload) { {'app.js': {nosrc: true}} }
    subject(:lookup) { manifest.lookup('app.js') }

    it 'raises an error' do
      expect { lookup }.to raise_error(::Rails::Assets::Manifest::ManifestInvalid)
    end
  end

  describe '#lookup' do
    subject(:entry) { manifest.lookup('app.js') }

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

  describe '#eager_load!' do
    it 'does load data' do
      expect(manifest).to receive(:data).and_call_original
      manifest.eager_load!
    end
  end

  describe '#data' do
    it 'does call load on each invocation' do
      expect(manifest).to receive(:load).twice.once.and_call_original
      2.times { manifest.send(:data) }
    end

    context 'with caching enabled' do
      subject(:manifest) { described_class.new(files: files, cache: true) }

      it 'only call load once' do
        expect(manifest).to receive(:load).once.and_call_original
        2.times { manifest.send(:data) }
      end
    end
  end
end
