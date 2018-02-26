require 'fastlane/action'
require_relative '../helper/sonar_wrapper_helper'

module Fastlane
  module Actions
    class SonarWrapperAction < Action
      def self.run(params)
        UI.message("The sonar_wrapper plugin is working!")
        scan_params = {
          derived_data_path: "./DerivedData",
          coverage: true
        }

        if params
          scan_params[:scheme] = params[:scan_scheme] if params[:scan_scheme]
          scan_params[:devices] = params[:scan_devices] if params[:scan_devices]
          Actions::ScanAction.run(scan_params)

          profdata = `find ../DerivedData -name "Coverage.profdata"`
          binary = `find ../DerivedData -path "*#{params[:product_name]}.app/#{params[:product_name]}"`

          `xcrun llvm-cov report -instr-profile #{profdata} #{binary}`

          Actions::SonarAction.run({})
          `rm -rf ./DerivedData`
        else
          UI.message("parameters are not specified.")
        end
      end

      def self.description
        "wrapper action of sonar"
      end

      def self.authors
        ["Yusuke Ohashi"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "This plugin extends sonar action and gives you one-stop action from scan to sonar."
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "SONAR_WRAPPER_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
          FastlaneCore::ConfigItem.new(key: :scan_scheme,
                               description: "A description of your option",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :scan_devices,
                               description: "A description of your option",
                                  optional: false,
                                      type: Array),
          FastlaneCore::ConfigItem.new(key: :product_name,
                               description: "A description of your option",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
