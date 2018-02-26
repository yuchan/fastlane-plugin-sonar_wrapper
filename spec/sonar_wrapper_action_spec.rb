describe Fastlane::Actions::SonarWrapperAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The sonar_wrapper plugin is working!")

      Fastlane::Actions::SonarWrapperAction.run(scan_scheme: 'MyApp', product_name: 'MyApp')
    end
  end
end
