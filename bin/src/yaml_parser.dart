import 'dart:io';

import 'package:yaml/yaml.dart';

import 'build_task.dart';
import 'generator_config.dart';
import 'project.dart';

class YamlParser {
  GeneratorConfig parse(File file) {
    final yamlString = file.readAsStringSync();
    final yaml = loadYaml(yamlString);

    final name = yaml['name'] ?? 'project';

    final projectsYaml = yaml['projects'];
    if (projectsYaml is! YamlMap || projectsYaml.isEmpty) {
      throw 'No projects on config';
    }

    final projects = projectsYaml.entries.map((entry) {
      final path = entry.key;
      final config = entry.value;

      if (config is! YamlMap || config.isEmpty) {
        throw 'No config for project $path';
      }

      final name = config['name'] ?? path;

      ProjectType? type;
      switch (config['type']) {
        case 'dart':
          type = ProjectType.dart;
          break;
        case 'flutter':
          type = ProjectType.flutter;
          break;
      }

      if (type == null) throw 'No type for project $path';

      LaunchConfig? launchConfig;
      final hasLaunchConfig = config.containsKey('launchConfig');
      if (hasLaunchConfig) {
        launchConfig = LaunchConfig();

        final launchConfigYaml = config['launchConfig'];
        if (launchConfigYaml is YamlMap && launchConfigYaml.isNotEmpty) {
          final flavors = launchConfigYaml['flavors'];
          if (flavors is List && flavors.isNotEmpty) {
            launchConfig = LaunchConfig(
              flavors: flavors.whereType<String>().toList(),
            );
          }
        }
      }

      List<BuildTask> buildTasks = [];
      final hasBuildTasks = config.containsKey('buildTasks');
      if (hasBuildTasks) {
        final tags = config['buildTasks'];
        if (tags is List && tags.isNotEmpty) {
          buildTasks = tags.whereType<String>().map(buildTaskFromTag).toList();
        }
      }

      return Project(
        name: name,
        path: path,
        type: type,
        launchConfig: launchConfig,
        buildTasks: buildTasks,
      );
    }).toList();

    return GeneratorConfig(name, projects);
  }

  BuildTask buildTaskFromTag(String tag) {
    final taskCandidates = BuildTask.values.where((t) => t.tag == tag);
    if (taskCandidates.isEmpty) throw 'Unknown build task';
    return taskCandidates.first;
  }
}
