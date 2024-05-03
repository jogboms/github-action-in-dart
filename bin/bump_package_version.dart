// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:args/args.dart';
import 'package:github_actions_toolkit/github_actions_toolkit.dart' as actions;

import 'utils.dart';

const logger = actions.log;
final env = Platform.environment;

final ArgParser parser = ArgParser()
  ..addOption(
    'versionBumpType',
    allowed: VersionBumpType.names,
    defaultsTo: VersionBumpType.patch.name,
    valueHelp: VersionBumpType.patch.name,
  )
  ..addOption(
    'flavor',
    allowed: Flavor.names,
    defaultsTo: Flavor.dev.name,
    valueHelp: Flavor.dev.name,
  );

void main(List<String> arguments) async {
  final ArgResults args = parser.parse(arguments);
  final String versionBumpType = args['versionBumpType'] as String;
  final String flavor = args['flavor'] as String;

  final version = await bumpPackageVersion(VersionBumpType.fromName(versionBumpType));
  logger.info(version);

  final [versionName, buildNumber] = version.split('+');
  final tag = 'v$version-$flavor';

  actions.setOutput('version_name', versionName);
  actions.setOutput('build_number', buildNumber);
  actions.setOutput('release_version', version);
  actions.setOutput('tag', tag);
}
