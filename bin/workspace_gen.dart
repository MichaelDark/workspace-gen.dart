import 'dart:convert';
import 'dart:io';

import 'src/generator.dart';
import 'src/yaml_parser.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) throw 'No yaml config provided';
  final path = arguments.first;

  final file = File(path);
  if (!file.existsSync()) throw 'Yaml config file not found';

  final parser = YamlParser();
  final generatorConfig = parser.parse(file);

  final name = generatorConfig.name;
  final projects = generatorConfig.projects;

  final codeWorkspaceJson = Generator(projects).generateJson();
  final jsonString = JsonEncoder.withIndent("  ").convert(codeWorkspaceJson);

  final outputsDir = Directory('outputs');
  if (!outputsDir.existsSync()) outputsDir.createSync();

  File('outputs/$name.code-workspace').writeAsString(jsonString);
}
