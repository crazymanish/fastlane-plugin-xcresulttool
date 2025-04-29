require 'fastlane/action'
require_relative '../helper/xcresulttool_helper'

module Fastlane
  module Actions
    class XcresulttoolCompareAction < Action
      def self.run(params)
        args = ["compare"]
        
        # Validate result bundle paths
        Helper::XcresulttoolHelper.validate_result_bundle_path(params[:result_bundle_path])
        Helper::XcresulttoolHelper.validate_result_bundle_path(params[:baseline_path])
        
        # Add required arguments
        args << params[:result_bundle_path] # Use positional argument for comparison path
        args << "--baseline-path" << params[:baseline_path]
        
        # Add comparison output options
        args << "--summary" if params[:summary]
        args << "--test-failures" if params[:test_failures]
        args << "--tests" if params[:tests]
        args << "--build-warnings" if params[:build_warnings]
        args << "--analyzer-issues" if params[:analyzer_issues]
        
        # Add optional output format and path if supported
        args << "--format" << params[:format] if params[:format] && params[:format_supported]
        args << "--output-path" << params[:output_path] if params[:output_path]
        
        args << "--verbose" if params[:verbose]
        
        # Execute the command
        result = Helper::XcresulttoolHelper.execute_command(args)
        
        if params[:output_path]
          UI.success("Comparison results saved to #{params[:output_path]}")
        else
          return result
        end
      end

      def self.description
        "Compare two Result Bundles using xcresulttool"
      end

      def self.authors
        ["crazymanish"]
      end

      def self.return_value
        "The output of the xcresulttool compare command as a string, or nil if output_path is specified"
      end

      def self.details
        "This action compares two Xcode result bundles (.xcresult) and reports differences using Apple's xcresulttool compare subcommand"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :result_bundle_path,
            description: "Path to the .xcresult bundle to be compared",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :baseline_path,
            description: "Path to the baseline .xcresult bundle for comparison",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :summary,
            description: "Include the differential summary info in the output",
            optional: true,
            default_value: true,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :test_failures,
            description: "Include the differential test failures info in the output",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :tests,
            description: "Include the differential tests info in the output",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_warnings,
            description: "Include the differential build warnings info in the output",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :analyzer_issues,
            description: "Include the differential analyzer issues info in the output",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :format,
            description: "Output format (json, flat, human-readable)",
            optional: true,
            default_value: "json",
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :format_supported,
            description: "Whether the format option is supported by your version of xcresulttool (newer versions only)",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_path,
            description: "Path to save comparison results",
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
          'xcresulttool_compare(
            result_bundle_path: "path/to/Test.xcresult",
            baseline_path: "path/to/Baseline.xcresult",
            summary: true,
            test_failures: true
          )',
          'xcresulttool_compare(
            result_bundle_path: "path/to/Test.xcresult",
            baseline_path: "path/to/Baseline.xcresult",
            summary: true,
            tests: true,
            build_warnings: true,
            analyzer_issues: true,
            output_path: "comparison_results.txt"
          )'
        ]
      end

      def self.category
        :testing
      end
    end
  end
end