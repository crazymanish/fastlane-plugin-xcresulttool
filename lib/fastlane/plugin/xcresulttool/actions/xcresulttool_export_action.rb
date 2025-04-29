require 'fastlane/action'
require_relative '../helper/xcresulttool_helper'

module Fastlane
  module Actions
    class XcresulttoolExportAction < Action
      def self.run(params)
        args = ["export"]
        
        # Validate result bundle path
        Helper::XcresulttoolHelper.validate_result_bundle_path(params[:result_bundle_path])
        
        # Add required arguments
        args << "--path" << params[:result_bundle_path]
        
        # Add optional arguments
        args << "--format" << params[:format] if params[:format]
        args << "--output-path" << params[:output_path] if params[:output_path]
        args << "--output-dir" << params[:output_dir] if params[:output_dir]
        
        # Handle export items
        if params[:export_items]
          params[:export_items].each do |item|
            args << "--export-item" << item
          end
        end
        
        args << "--verbose" if params[:verbose]
        
        # Execute the command
        result = Helper::XcresulttoolHelper.execute_command(args)
        
        output_location = params[:output_path] || params[:output_dir]
        if output_location
          UI.success("Results exported to #{output_location}")
        else
          return result
        end
      end

      def self.description
        "Export Result Bundle contents using xcresulttool"
      end

      def self.authors
        ["crazymanish"]
      end

      def self.return_value
        "The output of the xcresulttool export command as a string, or nil if output_path or output_dir is specified"
      end

      def self.details
        "This action exports content from an Xcode result bundle (.xcresult) using Apple's xcresulttool export subcommand"
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
            key: :output_path,
            description: "Path to save output file",
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
            description: "Array of items to export",
            optional: true,
            type: Array
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
          'xcresulttool_export(
            result_bundle_path: "path/to/Test.xcresult",
            output_path: "output.json"
          )',
          'xcresulttool_export(
            result_bundle_path: "path/to/Test.xcresult",
            output_dir: "export_directory",
            export_items: ["logs", "diagnostics"]
          )'
        ]
      end

      def self.category
        :testing
      end
    end
  end
end