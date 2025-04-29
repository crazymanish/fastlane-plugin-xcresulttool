require 'fastlane/action'
require_relative '../helper/xcresulttool_helper'

module Fastlane
  module Actions
    class XcresulttoolMergeAction < Action
      def self.run(params)
        args = ["merge"]
        
        # Validate source result bundles
        source_results = params[:source_results]
        UI.user_error!("At least one source result bundle path must be provided") if source_results.nil? || source_results.empty?
        
        source_results.each do |path|
          Helper::XcresulttoolHelper.validate_result_bundle_path(path)
        end
        
        # Add required output path
        output_path = params[:output_path]
        UI.user_error!("Output path must be provided") if output_path.nil? || output_path.empty?
        args << "--output-path" << output_path
        
        # Add source result bundle paths directly as arguments
        source_results.each do |path|
          args << path
        end
        
        # Add verbose option if needed
        args << "--verbose" if params[:verbose]
        
        # Execute the command
        Helper::XcresulttoolHelper.execute_command(args)
        
        UI.success("Result bundles merged to #{output_path}")
      end

      def self.description
        "Merge multiple Result Bundles using xcresulttool"
      end

      def self.authors
        ["crazymanish"]
      end

      def self.return_value
        nil
      end

      def self.details
        "This action merges multiple Xcode result bundles (.xcresult) into a single bundle using Apple's xcresulttool merge subcommand"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :source_results,
            description: "Array of paths to .xcresult bundles to merge",
            optional: false,
            type: Array
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_path,
            description: "Path where to save the merged result bundle",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :verbose,
            description: "Enable verbose output",
            optional: true,
            default_value: false,
            is_string: false
          )
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.example_code
        [
          'xcresulttool_merge(
            source_results: ["path/to/Test1.xcresult", "path/to/Test2.xcresult"],
            output_path: "path/to/MergedResults.xcresult"
          )'
        ]
      end

      def self.category
        :testing
      end
    end
  end
end