# pachyderm-log-analysis

Project to demonstrate analyzing logs for error and warning messages utilizing [Pachyderm](https://pachyderm.com)

# Setup

- Goal: To demonstrate how to use Pachyderm to analyze logs for error and warning messages
- Features:
  - [Pachyderm](https://pachyderm.com)
  - [Kubernetes](https://kubernetes.io)
  - [Docker](https://www.docker.com)
  - [Helm](https://helm.sh)
  - [Microk8s](https://microk8s.io)
  - [Pachyderm Pipelines](https://docs.pachyderm.com/latest/concepts/pipeline-concepts/)
  - [Bash Scripts](https://www.gnu.org/software/bash/)
  - [Markdown](https://en.wikipedia.org/wiki/Markdown)
- Assumptions:
  - [Kubernetes](https://kubernetes) is installed
    - I used [Microk8s](https://microk8s.io) to install and manage [Kubernetes](https://kubernetes)
    - Microk8s installed by using snap:
    ```bash
    sudo snap install microk8s --classic --channel=1.21
    sudo usermod -a -G microk8s $USER
    sudo chown -f -R $USER ~/.kube
    alias kubectl='microk8s kubectl'
    ```
    - Configuration issues:
      - By default, persistent volumes storage on Microk8s is not enabled.
      - To enable persistent volumes, run the following command:
        ```bash
        microk8s.enable storage
        ```
      - By default, dns is not enabled.
      - To enable dns, run the following command:
        ```bash
        microk8s.enable dns
        ```
      - [Pachctl](https://docs.pachyderm.com/latest/reference/pachctl/pachctl/) expects to be able to load k8s config
        from the default location.
      - To make sure this is the case, run the following command:
        ```bash
        cd $HOME
        mkdir .kube
        cd .kube
        microk8s config > config
        ```
      - Instructions for this can be found
        at [https://microk8s.io/docs/working-with-kubectl] (https://microk8s.io/docs/working-with-kubectl)
      - Lastly, I recommend enabling the dashboard provide with microk8s version 1.19+.
        ```bash
        microk8s.enable dashboard
        microk8s dashboard-proxy &
        ``` 
  - [Pachyderm-CLI](https://pachyderm.com) is installed
    - https://docs.pachyderm.com/latest/getting-started/local-installation/#install-pachctl
    ```bash
    curl -o /tmp/pachctl.deb -L https://github.com/pachyderm/pachyderm/releases/download/v2.1.7/pachctl_2.1.7_amd64.deb && sudo dpkg -i /tmp/pachctl.deb  
    ```
  - [Docker](https://www.docker.com) is installed:
    ```bash
    sudo apt-get update
    sudo apt-get install docker.io
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
    ```
  - Kubernetes is running (user has been added to the `microk8s` group):
    ```bash
    microk8s start
    microk8s enable storage
    microk8s enable dns
    microk8s enable dashboard
    microk8s dashboard-proxy &
    ```
  - [Helm](https://helm.sh) is installed
    ```bash
    microk8s enable helm3 
    ```
  - [Pachyderm](https://pachyderm.com) is running (I aliased `helm` to `microk8s helm3`):

  - I used the following:
    ```bash
    helm repo add pach https://helm.pachyderm.com
    helm repo update
    helm install pachd pach/pachyderm --set deployTarget=LOCAL
    pachctl config import-kube local --overwrite
    pachctl config set active-context local
    pachctl port-forward &
    ```

# Getting Started

- Setup of the demo pipelines can be accomplished by running the following commands:
  ```bash
  git clone https://github.com/MHarris021/pachyderm-log-analysis.git
  cd pachyderm-log-analysis
  ./setupDemo.sh 1.0.0 <true|false> <docker.io/myrepo> <myimage> [/my/input/dir]
  ```
  - The first argument is the version of the demo pipelines.
  - The second argument is whether or not to use cached build images.
  - The third argument is the docker repo to use for the demo pipelines.
  - The fourth argument is the docker image to use for the demo pipelines.
  - The fifth argument is the path to the directory containing the input data. The default is `./data/test/logs`.
- Running the above script will do the following:
  - create a docker image for the demo pipelines and push it to the docker repo.
  - create a pachyderm repo named `logs`.
  - load data from the input directory `[my/input/directory]` into the repo.
  - create 5 pachyderm pipelines:
    - `log-analyzer-warning`
    - `log-analyzer-error`
    - `log-analyzer-reducer`
    - `combine-log-analysis`
    - `create-log-analysis-report`
  - and then run the pipelines.
- User will then need fetch the generated report from the `create-log-analysis-report` pipeline.
  ```bash
  pachctl list file create-log-analysis-report@master:/
  pachctl get file create-log-analysis-report@master:/log-analysis-report.txt| cat
  ```
  Something similar can be done with each of the pipelines if desired to check output.
- The output should look like the
  file [./data/test/output/log-analysis-report.txt](./data/test/output/log-analysis-report.txt).
  ```
  Log Analysis Report:

  Log file example1.log found in /pfs/logs has 5 warning(s), 4 error(s)
  Log file example2.log found in /pfs/logs has 4 warning(s), 3 error(s)
  Log file example3.log found in /pfs/logs has 0 warning(s), 4 error(s)
  Log file example4.log found in /pfs/logs has 4 warning(s), 0 error(s)
  Log file example5.log found in /pfs/logs has 5 warning(s), 1 error(s)

  ```
- The demo pipelines can be run again to check that the output is the same.
  ```bash
  ./updateDemo.sh 1.0.1 <true|false> <docker.io/myrepo> <myimage> [/my/input/dir]
  ```
  This will tear down the demo pipelines and re-deploy them.

# Assumptions

- The log files are in the `[my/input/directory]` directory.
- The log files are in the format `[log-file-name].log`.
- The log files contain at least 0 warning(s) and 0 error(s).
- Only lines are counted, so multiple `warning`s or `error`s in the same line will be counted as 1.
- The search for `warning`s and `error`s is case-insensitive. For example, `Warning` and `warning` will both be counted
  as 1.
- The search for `warning`s and `error`s ignores whitespace.
- The search for `warning`s and `error`s ignores punctuation. For example, `warning:` and `warning;` will both be
  counted as 1.
- The search for `warning`s and `error`s matches against the whole word only. For example, `warning` will not
  match `warning1`, `warning2`, `warnings`, etc.
- The search terms are parameterized. For example, `warning` and `error` are used as search terms, but different search
  terms can be used. They are currently hardcoded in the file `[./scripts/createPipelines.sh]`
  and `[./scripts/updatePipelines.sh]` They can be extracted in a future version and passed as parameters.
- The report generated by the `create-log-analysis-report` pipeline is in a human-readable format.
- All other pipeline output is in json format. The specific format of the json output is not important, but is
  documented in the shell script that uses it or creates it.

# Testing

- Unfortunately, the test suite is not very extensive. And relies upon visually inspecting the output to the provided
  expected report.
- I ran out of time to tests, but it should be easy to compare the output to the expected report through `diff` or other
  tool.
- I was uncertain how to determine when a pipeline is done running, so I used `pachctl list` to check the status of the
  pipelines. And then used `pachctl list file <pipeline>@<branch>:/` to determine if output had been created. A guide on
  testing pipelines would be helpful. I did use the guides on troubleshooting, datum inspection, and getting file output
  out, but I feel like this could have been improved or better explained.
- I extensively tested the pipelines in the `[./scripts/createPipelines.sh]` and `[./scripts/updatePipelines.sh]` files.
- I tested the shell scripts in the `[./src/scripts]` directory extensively.
- Testing is what lead me to create the scripts to help automate the process of creating and updating pipelines.
- I extensively used the kubernetes dashboard provided by microk8s to examine pipeline runs, pipeline log files, and
  used it to `exec` into the pipeline job containers.

# Design Goals

- I wanted to be able to explore pipeline DAGs and a more complicated architecture. This allowed me to better immerse
  myself in the technology.
- I wanted to be able to create pipelines that were more complex than the ones I had created before. I created the first
  2 in about 2-3 hours and wanted to better explore all that pachyderm offers.
- I chose to start my design using shell scripts instead of a real programming language. This caused a few issues when
  passing parameters around and some of the more complicated scripting logic.
- In the future, I would probably switch to a real programming language to allow for more sophisticated work.
- I was able to use `jsonnet` pipeline templates to create pipelines that were more complex than the ones I had created
  before. It's use allowed me to templatize the pipelines and pass them arguments. This enhanced their re-usability and
  power.
- I wanted to try to use the other pipeline types: `cron`, `service`, `spout` as wll, but ran out of time.

# Lessons Learned

- Running pipelines is a very powerful tool. It allows me to explore the technology and see how it works.
- Running multiple pipelines at once is a potentially great pattern, but needs to be balanced against resource
  constraints.
- Running 5 pipelines took longer than running 2 pipelines. This is because the pipelines are running in parallel (
  consuming more resources on my laptop). They also have a dependency to wait on one another to complete before further
  processing can occur.
- Studying the way data was passed around in the pipelines was a good way to learn how to use the `pachctl` command line
  tool.

# Future Work

- I would like to explore the other pipeline types: `cron`, `service`, `spout`.
- I envision running a `service` pipeline that allows a user to view the log analysis reports that have been run over
  time through a web based UI. Maybe Express or NextJS with a React frontend.
- I envision running a `spout` pipeline that would serve as a collection point for log files to be passed from other
  machines as messages or through some other event driven mechanism.
- I envision running a `cron` pipeline that would run a pipeline on a schedule to gather up log files and ship them off
  to either the `spout` pipeline to be analyzed or possibly used to rotate old logs and reports to archival storage.
- I would also like to better understand performance constraints on the pachyderm platform. And best practices around
  architecture.

# Final Thoughts

- Each script has been heavily tested and is working as expected.
- Each script has been heavily commented to explain how to use it and what it is doing.
- This was an enjoyable experience. I learned a lot about the technology and how it works. I would like to learn more.
