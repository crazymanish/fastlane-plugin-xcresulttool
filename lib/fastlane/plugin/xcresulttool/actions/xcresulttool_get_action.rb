require 'fastlane/action'
require_relative '../helper/xcresulttool_helper'

module Fastlane
  module Actions
    class XcresulttoolGetAction < Action
      def self.run(params)
        args = ["get"]
        
        # Validate result bundle path
        Helper::XcresulttoolHelper.validate_result_bundle_path(params[:result_bundle_path])
        
        # Add required arguments
        args << "--path" << params[:result_bundle_path]
        
        # Add optional arguments
        args << "--format" << params[:format] if params[:format]
        args << "--id" << params[:id] if params[:id]
        args << "--output-path" << params[:output_path] if params[:output_path]
        args << "--type" << params[:type] if params[:type]
        args << "--verbose" if params[:verbose]
        
        # Execute the command
        result = Helper::XcresulttoolHelper.execute_command(args)
        
        if params[:output_path]
          UI.success("Results saved to #{params[:output_path]}")
        else
          return result
        end
      end

      def self.description
        "Get Result Bundle contents using xcresulttool"
      end

      def self.authors
        ["crazymanish"]
      end

      def self.return_value
        "The output of the xcresulttool get command as a string, or nil if output_path is specified"
      end

      def self.details
        "This action extracts content from an Xcode result bundle (.xcresult) using Apple's xcresulttool get subcommand"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :result_bundle_path,
            description: "Path to the .xcresult bundle",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :format,
            description: "Output format (json, flat, human-readable)",
            optional: true,
            default_value: "json",
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :id,
            description: "ID for the get subcommand",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :type,
            description: "Content type for the get subcommand (e.g., 'action-testSummary', 'test-report')",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_path,
            description: "Path to save output",
            optional: true,
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
          'xcresulttool_get(
            result_bundle_path: "path/to/Test.xcresult",
            format: "json"
          )',
          'xcresulttool_get(
            result_bundle_path: "path/to/Test.xcresult",
            type: "action-testSummary",
            output_path: "test_summary.json"
          )',
          'xcresulttool_get(
            result_bundle_path: "path/to/Test.xcresult",
            type: "test-report"
          )'
        ]
      end

      def self.category
        :testing
      end
    end
  end
end