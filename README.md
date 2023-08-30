# Korbit AI mentor action

In order to use this Github action, you must already have an account on [mentor.korbit.ai](https://mentor.korbit.ai) and [generated your secret id/key](https://docs.korbit.ai/#/cli/cli_authentication).

This Github action will allow you to integrate within your pipeline the Korbit AI mentor scan.

## Secrets id/key

Once you have created your secret id/keys, you will need to add them into Github Action secrets.

- KORBIT_SECRET_ID
- KORBIT_SECRET_KEY

To know how to set those secrets for your repository on Github you can follow section of [Github official documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

Now you should be able to continue and setup your github action workflow.

## Inputs

| name                   | required | type    | default | description                                                                                                                                                                                                  |
| ---------------------- | -------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `path`                 | yes      | string  | `.`     | The path to the local file or folder to be scan.                                                                                                                                                             |
| `threshold_priority`   | false    | integer | `0`     | Issues found must be above this priority score to be presented (on a scale of 0-10).                                                                                                                         |
| `threshold_confidence` | false    | integer | `0`     | Issues found must be above this confidence score to be presented (on a scale of 0-10).                                                                                                                       |
| `headless`             | false    | boolean | `true`  | Will trigger an exit code if issues have been found on the given path (interrupting the pipeline).                                                                                                           |
| `headless_show_report` | false    | boolean | `false` | By default when the `headless` variable is set to `true`, nothing will be shown in the output logs. Setting `headless_show_report` variable to `true` will show Korbit scan report in the logs, in realtime. |
| **`secret_id`**        | true     | string  |         | The given secret id generated on [mentor.korbit.ai/profile](https://mentor.korbit.ai/profile)                                                                                                                |
| **`secret_key`**       | true     | string  |         | The given secret key generated on [mentor.korbit.ai/profile](https://mentor.korbit.ai/profile)                                                                                                               |

## Outputs

The action will print the final report, including any issues detected that meet your thresholds, in the [github action summary tab](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#example-of-adding-a-job-summary).

### Headless

As mention in the inputs, if you are using the `headless` option, the scan could exit with a `91` code. If your pipeline returns this code, it means that the pipeline will be stopped.

## Examples usage

The following are two examples of using Korbit AI mentor in your CI/CD.

1. First the scan will be run on every push you make to your repository.
   - [Korbit AI mentor Github application](https://github.com/apps/korbit-ai-mentor) is already doing that for you by default.
1. Secondly **on demand**, korbit will generate a scan on a specified file or folder. This is triggered manually from Github Action tab of your repository.

### On push

To create the relevant github action triggered on push, create a new workflow file `.github/workflows/korbit_mentor_check_on_push.yaml`.

```yml
name: On push repository scan
on: [push]

jobs:
  check_files:
    runs-on: ubuntu-latest
    name: An example of using the Korbit AI mentor github action
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Check file using local github action
        uses: korbit-ai/korbit-mentor-action@v1
        id: check
        with:
          path: "." # Change this to the folder you want to scan
          threshold_confidence: 9 # Set your own threshold (0-10)
          threshold_priority: 9 # Set your own threshold (0-10)
          headless_show_report: true
          headless: true
          secret_id: ${{ secrets.KORBIT_SECRET_ID }}
          secret_key: ${{ secrets.KORBIT_SECRET_KEY }}
```

**Note**: You can setup `.korbitignore` to ignore specific files/folders from being scans, see [documentation](https://docs.korbit.ai/#/code_scans/ignore_files).

### On workflow dispatch

To create the relevant github action that you can triggered manually, create a new workflow file `.github/workflows/korbit_mentor_check_on_demand.yaml`.

```yaml
name: Korbit mentor manual scan request

on:
  workflow_dispatch:
    inputs:
      path:
        description: "Path to scan"
        default: "."
        required: true
jobs:
  scan-code:
    name: An example of using the Korbit AI mentor github action
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - name: Scan path
        uses: korbit-ai/korbit-mentor-action@v1
        id: check
        with:
          path: ${{ github.event.inputs.path }}
          threshold_confidence: 10 # Set your own threshold (0-10)
          threshold_priority: 10 # Set your own threshold (0-10)
          headless: false
          secret_id: ${{ secrets.KORBIT_SECRET_ID }}
          secret_key: ${{ secrets.KORBIT_SECRET_KEY }}
```

## Troubleshooting

When setting up the Korbit AI mentor Github action, you might encounter some problems. If you see that the workflow, return a certain exit code here is the explanation of what they means:

| exit code | description                                                                                                                                                                |
| --------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|         0 | Everything went fine, congratulation.                                                                                                                                      |
|        90 | Something went wrong and we don't know why, please contact [support@korbit.ai](mailto:support@korbit.ai).                                                                  |
|        91 | You have set your action to run using the headless option, and Korbit AI mentor found issues in your code that are above the thresholds you set.                           |
|        92 | Something went wrong while we were analyzing your file(s), please contact [support@korbit.ai](mailto:support@korbit.ai)                                                    |
|        93 | The login credentials aren't set properly. Refer to "[Secrets id/key](#secrets-idkey)" section or in our [documentation](https://docs.korbit.ai/#/cli/cli_authentication). |
