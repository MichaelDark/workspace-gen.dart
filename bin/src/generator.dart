import 'build_task.dart';
import 'build_task_generator.dart';
import 'project.dart';

class Generator {
  final List<Project> projects;

  Generator(this.projects);

  Map<String, dynamic> generateJson() {
    final buildTaskGenerator = BuildTaskGenerator();

    return {
      'folders': [
        {'name': 'root', 'path': '.'},
        ...projects.map((p) => p.folder),
      ],
      'launch': {
        'configurations': [
          ...projects.map((p) => p.launchConfigurations).expand((e) => e),
        ],
        'compounds': [],
      },
      'tasks': {
        'version': '2.0.0',
        'tasks': [
          ...BuildTask.values.map((buildTask) {
            final taskProjects = projects
                .where((project) => project.buildTasks.contains(buildTask));
            return [
              ...taskProjects.map((project) =>
                  buildTaskGenerator.createTask(buildTask, project)),
              buildTaskGenerator.createTaskForAll(buildTask, taskProjects),
            ];
          }).expand((e) => e),
        ],
      },
      'extensions': {
        'recommendations': ['dart-code.dart-code', 'dart-code.flutter'],
        'unwantedRecommendations': [],
      },
      'settings': {
        'files.exclude': {
          for (final project in projects) project.path: true,
        }
      }
    };
  }
}

extension FolderExt on Project {
  Map<String, dynamic> get folder => {'name': name, 'path': path};
}

extension LaunchConfigExt on Project {
  List<Map<String, dynamic>> get launchConfigurations {
    final launchConfig = this.launchConfig;
    if (launchConfig == null) {
      return [];
    } else {
      final flavors = launchConfig.flavors;
      return [
        if (flavors.isEmpty) ...[
          createLaunchConfiguration(debug: true),
          createLaunchConfiguration(debug: false),
        ],
        for (final flavor in flavors) ...[
          createLaunchConfiguration(flavor: flavor, debug: true),
          createLaunchConfiguration(flavor: flavor, debug: false),
        ],
      ];
    }
  }

  Map<String, dynamic> createLaunchConfiguration({
    required bool debug,
    String? flavor,
  }) {
    final variant = debug ? 'debug' : 'release';
    final flavorName = flavor == null ? '' : '[$flavor]';
    return {
      'name': '$name $flavorName[$variant]',
      'request': 'launch',
      'type': 'dart',
      'cwd': '\${workspaceFolder:$name}',
      'program': '\${workspaceFolder:$name}/lib/main.dart',
      'args': [
        '--$variant',
        if (flavor != null) ...[
          '--flavor',
          flavor,
        ],
      ]
    };
  }
}
