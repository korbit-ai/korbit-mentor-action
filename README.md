# Korbit AI mentor action

In order to use this Github action, you must already have an account on [mentor.korbit.ai](https://mentor.korbit.ai) and [generated your secret id/key](https://docs.korbit.ai/cli/cli_authentication).

This Github action will allow you to integrate within your pipeline the Korbit AI mentor scan.

## Secrets id/key

Once you have created your secret id/keys, you will need to add them into Github Action secrets.

- KORBIT_SECRET_ID
- KORBIT_SECRET_KEY

To know how to set those secrets for your repository on Github you can follow section of [Github official documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

Now you should be able to continue and setup your github action workflow.

## Inputs

| name                 | required | type    | default | description                                                                                                                |
| -------------------- | -------- | ------- | ------- | -------------------------------------------------------------------------------------------------------------------------- |
| path                 | yes      | string  | `.`     | The path to the local file or folder to be scan.                                                                           |
| threshold_priority   | false    | integer | `0`     | Issues found must be above this priority score to be presented (on a scale of 0-10).                                       |
| threshold_confidence | false    | integer | `0`     | Issues found must be above this confidence score to be presented (on a scale of 0-10).                                     |
| headless             | false    | boolean | `true`  | Will trigger an exit code if issues have been found on the given path (interrupting the pipeline).                         |
| headless_show_report | false    | boolean | `false` | By default with `headless` variable set to `true`, nothing will be shown. Set this variable to `true` see realtime output. |
| **secret_id**        | true     | string  |         | The given secret id generated on [mentor.korbit.ai/profile](https://mentor.korbit.ai/profile)                              |
| **secret_key**       | true     | string  |         | The given secret key generated on [mentor.korbit.ai/profile](https://mentor.korbit.ai/profile)                             |

## Outputs

The action will print the report in the summary tab of your github action run.

## Example usage

We will present 2 ways of using Korbit AI mentor in your CI/CD.

1. First the scan will be run on every push you make to your repository.
   - [Korbit AI mentor Github application](https://github.com/apps/korbit-ai-mentor) is already doing that for you by default.
1. Secondly on demand on a specific file or folder, directly from Github Action tab on your repository.

### On push

Create a new workflow file `korbit_mentor_check_on_push.yaml`.

```yml
on: [push]

jobs:
  check_files:
    runs-on: ubuntu-latest
    name: An example of using the Korbit AI mentor github action
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Check file using local github action
        uses: ## TODO ADD IT HERE
        id: check
        with:
          path: "example"
          threshold_confidence: 9
          threshold_priority: 9
          headless_show_report: true
          headless: true
          secret_id: ${{ secrets.KORBIT_SECRET_ID }}
          secret_key: ${{ secrets.KORBIT_SECRET_KEY }}
```

**Note**: You can setup `.korbitignore` to ignore specific files/folders from being scans, see [documentation](https://docs.korbit.ai/code_scans/ignore_files).

### On workflow dispatch

You can also set a manual scan check on demand. Create the following `korbit_mentor_check_on_demand.yaml`.

```yaml
name: Korbit mentor

on:
  workflow_dispatch:
    inputs:
      path:
        description: "Path to scan"
        default: "." #
        required: true
env:
  KORBIT_SECRET_ID: ${{ secrets.KORBIT_SECRET_ID }}
  KORBIT_SECRET_KEY: ${{ secrets.KORBIT_SECRET_KEY }}
  KORBIT_HOST: ${{ secrets.KORBIT_HOST }}
jobs:
  scan-code:
    name: An example of using the Korbit AI mentor github action
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - name: Scan file
        uses: ## TODO ADD IT HERE
        id: check
        with:
          path: ${{ github.event.inputs.path }}
          threshold_confidence: 10 # Set your own threshold
          threshold_priority: 10 # Set your own threshold
          headless: false
          secret_id: ${{ secrets.KORBIT_SECRET_ID }}
          secret_key: ${{ secrets.KORBIT_SECRET_KEY }}
```
