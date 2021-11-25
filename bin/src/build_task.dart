class BuildTask {
  static const List<BuildTask> values = [
    analyze,
    pubGet,
    clean,
    localize,
    build
  ];

  static const BuildTask analyze = BuildTask(
    'analyze',
    'analyze',
    ['analyze'],
  );
  static const BuildTask pubGet = BuildTask(
    'pubGet',
    'pub get',
    ['pub', 'get'],
  );
  static const BuildTask clean = BuildTask(
    'clean',
    'clean',
    ['clean'],
  );
  static const BuildTask localize = BuildTask(
    'localize',
    'localize',
    ['gen-l10n'],
  );
  static const BuildTask build = BuildTask(
    'build',
    'build',
    [
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
  );

  final String tag;
  final String name;
  final List<String> args;

  const BuildTask(this.tag, this.name, this.args);
}
