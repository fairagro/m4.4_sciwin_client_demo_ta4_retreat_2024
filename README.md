# SciWIn-Client Demo
This repo contains the scripts to perform a small SciWIn-Client Demo. This instructions file will be updated to use new features when they are available. The commands stated below will perform the operations based on our [hello world repo](https://github.com/fairagro/m4.4_hello_world).

![](https://github.com/fairagro/m4.4_sciwin_client_demo_ta4_retreat_2024/blob/complete_run/workflow.svg)

## Demo Commands
To check if SciWIn is available type `s4n --version` which should output something like `s4n 0.6.0`.
### Initializing a Project
To begin the journey use `s4n init` to initialize a project in the current directory.
```bash
s4n init
```
Create a virtual environment
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
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
s4n workflow connect demo --from plot/o_results --to @outputs/out
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

We now have a full workflow which can be executed
```bash
s4n execute local workflows/demo/demo.cwl --pop population.csv --speakers speakers_revised.csv
```

However we did not use Docker containers, so this will work only on our computer.
take a look at the other examples to learn how to use Docker with s4n. https://github.com/fairagro/m4.4_sciwin_client_examples