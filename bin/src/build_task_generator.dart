import 'build_task.dart';
import 'project.dart';

class BuildTaskGenerator {
  Map<String, dynamic> createTask(BuildTask task, Project project) {
    String command;
    switch (project.type) {
      case ProjectType.flutter:
        command = 'flutter';
        break;
      case ProjectType.dart:
        command = 'dart';
        break;
    }

    return {
      'label': '[${project.path}] ${task.name}',
      'type': 'shell',
      'command': command,
      'group': 'build',
      'options': {
        'cwd': '\${workspaceFolder:${project.name}}',
      },
      'runOptions': {
        'instanceLimit': 1,
        'reevaluateOnRerun': false,
      },
      'args': task.args,
      'presentation': {
        'echo': true,
        'focus': false,
        'panel': 'shared',
        'showReuseMessage': true,
        'clear': false
      },
      'problemMatcher': []
    };
  }

  Map<String, dynamic> createTaskForAll(
    BuildTask task,
    Iterable<Project> projects,
  ) {
    return {
      'label': '[ALL] ${task.name}',
      'type': 'shell',
      'group': 'build',
      'runOptions': {
        'instanceLimit': 1,
        'reevaluateOnRerun': false,
      },
      'dependsOn': [
        ...projects.map((p) => '[${p.path}] ${task.name}'),
      ],
      'presentation': {
        'echo': true,
        'focus': false,
        'panel': 'shared',
        'showReuseMessage': true,
        'clear': false
      },
      'problemMatcher': []
    };
  }
}
