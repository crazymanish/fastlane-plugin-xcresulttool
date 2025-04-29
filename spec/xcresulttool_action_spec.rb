describe Fastlane::Actions::XcresulttoolAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The xcresulttool plugin is working!")

      Fastlane::Actions::XcresulttoolAction.run(nil)
    end
  end
end
