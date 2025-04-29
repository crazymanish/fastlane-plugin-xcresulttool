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
        args << "--path" << params[:result_bundle_path]
        args << "--baseline-path" << params[:baseline_path]
        
        # Add optional arguments
        args << "--format" << params[:format] if params[:format]
        args << "--output-path" << params[:output_path] if params[:output_path]
        
        # Add comparison filter flags
        args << "--only-changes" if params[:only_changes]
        args << "--only-new-tests" if params[:only_new_tests]
        args << "--only-deleted-tests" if params[:only_deleted_tests]
        args << "--only-test-status-changes" if params[:only_test_status_changes]
        args << "--only-performance-changes" if params[:only_performance_changes]
        
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
            key: :format,
            description: "Output format (json, flat, human-readable)",
            optional: true,
            default_value: "json",
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_path,
            description: "Path to save comparison results",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :only_changes,
            description: "Show only changes in comparison",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :only_new_tests,
            description: "Show only new tests in comparison",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :only_deleted_tests,
            description: "Show only deleted tests in comparison",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :only_test_status_changes,
            description: "Show only test status changes in comparison",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :only_performance_changes,
            description: "Show only performance changes in comparison",
            optional: true,
            default_value: false,
            is_string: false
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
            baseline_path: "path/to/Baseline.xcresult"
          )',
          'xcresulttool_compare(
            result_bundle_path: "path/to/Test.xcresult",
            baseline_path: "path/to/Baseline.xcresult",
            format: "human-readable",
            only_changes: true,
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