# xcresulttool plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-xcresulttool)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-xcresulttool`, add it to your project by running:

```bash
fastlane add_plugin xcresulttool
```

## About xcresulttool

A fastlane plugin that provides an interface to Apple's `xcrun xcresulttool` command line utility. This plugin allows you to extract, export, merge, compare, and analyze data from Xcode test result bundles (.xcresult) files.

The plugin includes dedicated actions for each `xcresulttool` subcommand, making it easy to integrate with your fastlane workflows.

## Actions

### xcresulttool

The main action that supports all subcommands. You can use this action with a `subcommand` parameter to access all functionalities.

```ruby
xcresulttool(
  subcommand: "get",
  result_bundle_path: "path/to/Test.xcresult",
  format: "json",
  type: "action-testSummary"
)
```

### xcresulttool_get

Extract content from an .xcresult bundle:

```ruby
xcresulttool_get(
  result_bundle_path: "path/to/Test.xcresult",
  type: "action-testSummary",
  format: "json",
  output_path: "test_summary.json" # optional
)
```

### xcresulttool_export

Export content from an .xcresult bundle:

```ruby
xcresulttool_export(
  result_bundle_path: "path/to/Test.xcresult",
  output_path: "output.json",
  format: "json"
)
```

### xcresulttool_metadata

Get metadata from an .xcresult bundle:

```ruby
xcresulttool_metadata(
  result_bundle_path: "path/to/Test.xcresult",
  format: "human-readable",
  output_path: "metadata.txt" # optional
)
```

### xcresulttool_merge

Merge multiple .xcresult bundles into a single bundle:

```ruby
xcresulttool_merge(
  source_results: ["path/to/Test1.xcresult", "path/to/Test2.xcresult"],
  output_path: "path/to/MergedResults.xcresult"
)
```

### xcresulttool_compare

Compare two .xcresult bundles and report differences:

```ruby
xcresulttool_compare(
  result_bundle_path: "path/to/Test.xcresult",
  baseline_path: "path/to/Baseline.xcresult",
  format: "human-readable",
  only_changes: true,
  output_path: "comparison_results.txt" # optional
)
```

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Common Use Cases

- Extract test summaries to track pass/fail rates over time
- Export test attachments (screenshots, logs) for debugging
- Merge test results from parallel test runs
- Compare test results between different runs or branches
- Access test metadata for reporting

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
