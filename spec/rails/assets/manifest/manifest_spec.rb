# frozen_string_literal: true

require 'tempfile'
require 'pathname'

RSpec.describe Rails::Assets::Manifest::Manifest do
  subject(:manifest) { described_class.new(file) }

  let(:tmp) { Pathname.new(Dir.mktmpdir('manifest')) }
  let(:payload) do
    {'app.js': 'app-digest.js'}
  end
  let(:tmpfile) { tmp.join('manifest.json').open('w') }
  let(:file) { tmp.join('manifest.json') }

  after { tmp.rmtree }

  before do
    tmp.join('manifest.json').open('w') {|f| f.write JSON.generate(payload) }
  end

  context 'with invalid entry' do
    subject(:lookup) { manifest.lookup('app.js') }

    let(:payload) { {'app.js': {nosrc: true}} }

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

  # rubocop:disable RSpec/SubjectStub
  # rubocop:disable RSpec/MessageSpies
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
      subject(:manifest) { described_class.new(file, cache: true) }

      it 'only call load once' do
        expect(manifest).to receive(:load).once.and_call_original
        2.times { manifest.send(:data) }
      end
    end
  end
  # rubocop:enable RSpec/MessageSpies
  # rubocop:enable RSpec/SubjectStub
end
