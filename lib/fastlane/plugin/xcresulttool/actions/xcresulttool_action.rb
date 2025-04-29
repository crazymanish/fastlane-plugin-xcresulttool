require 'fastlane/action'
require_relative '../helper/xcresulttool_helper'

module Fastlane
  module Actions
    class XcresulttoolAction < Action
      def self.run(params)
        subcommand = params[:subcommand]
        args = [subcommand]

        # Common parameters
        result_bundle_path = params[:result_bundle_path]
        Helper::XcresulttoolHelper.validate_result_bundle_path(result_bundle_path) if result_bundle_path
        
        case subcommand
        when "get"
          args << "--path" << params[:result_bundle_path]
          args << "--format" << params[:format] if params[:format]
          args << "--id" << params[:id] if params[:id]
          args << "--output-path" << params[:output_path] if params[:output_path]
          args << "--type" << params[:type] if params[:type]
        
        when "export"
          args << "--path" << params[:result_bundle_path]
          args << "--format" << params[:format] if params[:format]
          args << "--output-path" << params[:output_path] if params[:output_path]
          args << "--output-dir" << params[:output_dir] if params[:output_dir]
          args << "--export-items" << params[:export_items].join(" ") if params[:export_items]
          
        when "graph"
          UI.important("Warning: 'graph' subcommand is deprecated and will be removed in a future release.")
          UI.important("Consider using 'xcresulttool get test-report' instead.")
          args << "--path" << params[:result_bundle_path]
          args << "--format" << params[:format] if params[:format]
          
        when "metadata"
          args << "--path" << params[:result_bundle_path]
          args << "--format" << params[:format] if params[:format]
          
        when "formatDescription"
          UI.important("Warning: 'formatDescription' subcommand is deprecated and will be removed in a future release.")
          
        when "merge"
          args << "--output-path" << params[:output_path] if params[:output_path]
          args += params[:source_results].map { |path| ["--input-path", path] }.flatten if params[:source_results]
          
        when "compare"
          args << "--path" << params[:result_bundle_path]
          args << "--baseline-path" << params[:baseline_path] if params[:baseline_path]
          args << "--format" << params[:format] if params[:format]
          args << "--only-changes" if params[:only_changes]
          args << "--only-new-tests" if params[:only_new_tests]
          args << "--only-deleted-tests" if params[:only_deleted_tests]
          args << "--only-test-status-changes" if params[:only_test_status_changes]
          args << "--only-performance-changes" if params[:only_performance_changes]
          
        else
          UI.user_error!("Unsupported subcommand: #{subcommand}. Available subcommands: get, export, graph, metadata, formatDescription, merge, compare")
        end
        
        # Additional parameters that could be passed to any subcommand
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
        "A fastlane plugin for xcresulttool"
      end

      def self.authors
        ["crazymanish"]
      end

      def self.return_value
        "For most subcommands, returns the output of the xcresulttool command as a string. When an output path is specified, returns nil but saves the output to the specified path."
      end

      def self.details
        "This plugin provides a fastlane interface to Apple's xcresulttool command line utility, which is used to extract and process data from Xcode's .xcresult bundles. It supports all xcresulttool subcommands: get, export, graph, metadata, formatDescription, merge, and compare."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :subcommand,
            description: "The xcresulttool subcommand to run (get, export, graph, metadata, formatDescription, merge, compare)",
            verify_block: proc do |value|
              valid_subcommands = ["get", "export", "graph", "metadata", "formatDescription", "merge", "compare"]
              UI.user_error!("Unsupported subcommand: '#{value}'. Available subcommands: #{valid_subcommands.join(", ")}") unless valid_subcommands.include?(value)
            end,
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :result_bundle_path,
            description: "Path to the .xcresult bundle",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :format,
            description: "Output format (json, flat, human-readable)",
            optional: true,
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
            key: :output_dir,
            description: "Directory to save output files",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :export_items,
            description: "Items to export (array of strings)",
            optional: true,
            type: Array
          ),
          FastlaneCore::ConfigItem.new(
            key: :source_results,
            description: "Array of xcresult bundle paths to merge",
            optional: true,
            type: Array
          ),
          FastlaneCore::ConfigItem.new(
            key: :baseline_path,
            description: "Path to baseline .xcresult bundle for comparison",
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
          'xcresulttool(
            subcommand: "get",
            result_bundle_path: "path/to/Test.xcresult",
            format: "json",
            type: "action-testSummary"
          )',
          'xcresulttool(
            subcommand: "export",
            result_bundle_path: "path/to/Test.xcresult",
            output_path: "output.json",
            format: "json"
          )',
          'xcresulttool(
            subcommand: "compare",
            result_bundle_path: "path/to/Test.xcresult",
            baseline_path: "path/to/Baseline.xcresult",
            format: "json",
            only_changes: true
          )',
          'xcresulttool(
            subcommand: "merge",
            output_path: "merged.xcresult",
            source_results: ["result1.xcresult", "result2.xcresult"]
          )'
        ]
      end

      def self.category
        :testing
      end
    end
  end
end
