import 'build_task.dart';

enum ProjectType { flutter, dart }

class Project {
  final ProjectType type;
  final String name;
  final String path;
  final LaunchConfig? launchConfig;
  final List<BuildTask> buildTasks;

  Project({
    required this.type,
    required this.name,
    required this.path,
    this.launchConfig,
    required this.buildTasks,
  });
}

class LaunchConfig {
  final List<String> flavors;

  LaunchConfig({this.flavors = const []});
}
