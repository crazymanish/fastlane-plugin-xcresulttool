require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class XcresulttoolHelper
      # class methods that you define here become available in your action
      # as `Helper::XcresulttoolHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the xcresulttool plugin helper!")
      end

      # Execute xcresulttool command with given arguments
      def self.execute_command(command_args)
        cmd = ['xcrun', 'xcresulttool'] + command_args
        UI.verbose("Executing command: #{cmd.join(' ')}")
        
        result = ''
        status = FastlaneCore::CommandExecutor.execute(
          command: cmd,
          print_all: false,
          print_command: true,
          output: proc { |line| result << line },
          error: proc { |line| UI.error(line) }
        )
        
        if status != 0
          UI.user_error!("Command failed with status #{status}")
        end
        
        return result
      end

      # Validate that a result bundle path exists
      def self.validate_result_bundle_path(result_bundle_path)
        UI.user_error!("Result bundle not found at path: #{result_bundle_path}") unless File.exist?(result_bundle_path)
      end
    end
  end
end
