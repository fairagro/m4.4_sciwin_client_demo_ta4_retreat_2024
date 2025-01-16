# SciWIn-Client Demo
This repo contains the scripts to perform a small SciWIn-Client Demo. This instructions file will be updated to use new features when they are available. The commands stated below will perform the operations based on our [hello world repo](https://github.com/fairagro/m4.4_hello_world).

## Preparation and Cleanup
To prepare the environment and to download all neccessary files you just need to execute the `Makefile` (maybe adjust `s4n` location before)
```bash
make
```
This will download all needed files from the [hello world repo](https://github.com/fairagro/m4.4_hello_world) and creates a shell script to activate environments.
Run 'source set_env.sh' to apply the environment changes to the current shell.
```bash
source set_env.sh
```

To reset the directory execute the clean command which will restore the initial state.
```bash
make clean
```

## Demo Commands
To check if SciWIn is available type `s4n --version` which should output something like `s4n 0.1.0`.
### Initializing a Project
To begin the journey use `s4n init` to initialize a project in the current directory.
```bash
s4n init
```
### Creation of CommandLineTools
To create the two CommandLineTools needed for the demo you just have to prefix the execution commands with `s4n tool create` or `s4n run`.
#### Calculation
To create the `calculation.cwl` tool run the following command:
```bash
s4n tool create python calculation.py --population population.csv --speakers speakers.csv
```
which will output something like
```
📂 The current working directory is /home/ubuntu/sciwin_test
▶️  Executing command: python calculation.py --population population.csv --speakers speakers.csv
Total population: 7694245029
            language    speakers  percentage
0             Bangla   300000000    3.899018
1    Egyptian Arabic   100542400    1.306722
2            English  1132366680   14.717060
3             German   134993040    1.754468
4         Indonesian   198996550    2.586304
5           Japanese   128000000    1.663581
6         Portuguese   475300000    6.177344
7            Punjabi   125000000    1.624591
8            Russian   154000000    2.001496
9  Standard Mandarin  1090951810   14.178803

📜 Found changes:
        - results.csv

📄 Created CWL file workflows/calculation/calculation.cwl
```
#### Plot
The Plot tool will use the created results.csv. The creation command is 
```bash
s4n run python plot.py --results results.csv
```
which will lead to the following output:
```
📂 The current working directory is /home/ubuntu/sciwin_test
▶️  Executing command: python plot.py --results results.csv

📜 Found changes:
        - results.svg

📄 Created CWL file workflows/plot/plot.cwl
```

### Execution with SciWIn
The command is `s4n execute local` which can be shortened by `s4n ex l`
#### Execution of CommandLineTools
You can execute CWL CommandLineTools in a custom runner on all major systems (Windows, Mac, Linux). The custom runner does not support containerization yet, so you need to make sure all required tools are available. The runner is work in progress!

##### Execution with arguments
You may need to change the arguments provided in CWL. You can either do this by giving the arguments appended to the command or use an input yaml file:
```yml
population:
  class: File
  location: population.csv
speakers:
  class: File
  location: speakers_revised.csv
```
```bash
s4n execute local workflows/calculation/calculation.cwl inputs.yml 
```
or give the separated arguments
```bash
s4n ex l workflows/calculation/calculation.cwl --speakers speakers_revised.csv --population population.csv 
```

##### Execution with no arguments
SciWIn client adds defaults to your tools so you can just rerun the cwl without any parameters:
```
s4n ex l workflows/plot/plot.cwl 
```
Outputs:
```
💻 Executing workflows/plot/plot.cwl using SciWIn's custom runner. Use `--runner cwltool` to use reference runner (if installed). SciWIn's runner currently only supports 'CommandLineTools'!
📁 Created staging directory: "/tmp/.tmph9kGRs"
⏳ Executing Command: `python plot.py --results /tmp/.tmph9kGRs/results.csv`
📜 Wrote output file: "/home/ubuntu/sciwin_test/results.svg"
{
  "results": {
    "location": "file:///home/ubuntu/sciwin_test/results.svg",
    "basename": "results",
    "class": "File",
    "checksum": "sha1$91e864f57d592c85ab3d4ef52162f3d05e5477aa",
    "size": 72865,
    "path": "/home/ubuntu/sciwin_test/results.svg"
  }
}
✔️  Command Executed with status: success!
```

### Workflow Creation
#### Workflow Creation
To create a Workflow with name `demo` simply call 
```bash
s4n workflow create demo
```
which will output
```
📄 Created new Workflow file: workflows/demo/demo.cwl
```

#### Connecting Tools
To connect the steps in the workflow you need to call `s4n workflow connect` a couple of times.

##### Connecting Inputs
First we will connect the `calculation` tool to the input sockets. The tool has two inputs which we will connect to the `speaker`s and `pop` input.
```bash
s4n workflow connect demo --from @inputs/speakers --to calculation/speakers
s4n workflow connect demo --from @inputs/pop --to calculation/population
```
An example output looks like
```
➕ Added step calculation to workflow
➕ Added or updated connection from inputs.speakers to calculation/speakers in workflow
✔️  Updated Workflow workflows/demo/demo.cwl!
```

##### Connecting Tools
We now will connect the `plot` and the `calculation` tool. We will map results-output to results-input.
```bash
s4n workflow connect demo --from calculation/results --to plot/results
```
An example output looks like
```
🔗 Found step calculation in workflow. Not changing that!
➕ Added step plot to workflow
✔️  Updated Workflow workflows/demo/demo.cwl!
```

##### Connecting to output
To get the results file we will connect the result of the plot step to out.
```bash
s4n workflow connect demo --from plot/results --to @outputs/out
```
which outputs
```
➕ Added or updated connection from plot/results to outputs.out in workflow!
✔️  Updated Workflow workflows/demo/demo.cwl!
```

To commit a simple call is needed:
```bash
s4n workflow save demo
```

Visualization can be made with
```bash
cwltool --print-dot workflows/demo/demo.cwl | dot -Tsvg > workflow.svg
```

We now have a full workflow which can be executed
```bash
s4n execute local workflows/demo/demo.cwl --pop population.csv --speakers speakers_revised.csv
```
or `s4n execute workflows/demo/demo.cwl --pop population.csv --speakers speakers_revised.csv` in a later stage (execution branch currently only supports commandlinetools)
