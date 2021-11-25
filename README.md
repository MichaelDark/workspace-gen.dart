# VS Code `.code-workspace` file generator
(for monorepositories with Dart and Flutter projects)

## TL;DR;

1. Create yaml file `config.yaml` (check #Format section)
2. Run:
   `workspace_gen.exe path/to/config.yaml` (`workspace_gen.exe` works on Win and UNIX systems)
3. Copy your `.code-workspace` file from `outputs/` directory

## Example

Check out the example of `config.yaml` and the generated output:
[config.yaml](example/config.yaml)
[project_name.code-workspace](example/project_name.code-workspace)

## Format

```yaml
name: project_name # Required. Will be used for `.code-workspace` filename.
projects: # Required. No projects - no workspace ¯\_(ツ)_/¯
  # project #1
  example_app: # Required. Path to flutter/dart project, relative to workspace location.
    type:
      flutter # Required. Type of the project
      # `dart` or `flutter`

    name:
      Flutter Project # Optional. Name of the project.
      # This name will be shown in VS Code Explorer.
      # Default - use project path as name

    launchConfig: # Optional. If present - generate launch tasks (debug/release).
      # Default - no launch tasks

      flavors: # Optional. If present - generate launch tasks using specified flavors.
        # Default - no build tasks
        - dev
        - prod

    buildTasks: # Optional. If present - generate build tasks.
      # Available values:
      # - analyze
      # - pubGet
      # - clean
      # - build (build_runner build --delete-conflicting-outputs)
      # - localize (gen-l10n)

      - analyze
      - pubGet
      - clean
      - build
      - localize
```
