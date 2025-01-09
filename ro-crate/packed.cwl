{
    "$graph": [
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InitialWorkDirRequirement",
                    "listing": [
                        {
                            "entryname": "calculation.py",
                            "entry": "import pandas as pd\nimport argparse\n\nparser = argparse.ArgumentParser(prog=\"python calculation.py\", description=\"Calculates the percentage of speakers for each language\")\nparser.add_argument(\"-p\", \"--population\", required=True, help=\"Path to the population.csv File\")\nparser.add_argument(\"-s\", \"--speakers\", required=True, help=\"Path to the speakers.csv File\")\n\nargs = parser.parse_args()\n\ndf = pd.read_csv(args.population)\nsum = df[\"population\"].sum()\n\nprint(f\"Total population: {sum}\")\n\ndf = pd.read_csv(args.speakers)\ndf[\"percentage\"] = df[\"speakers\"] / sum * 100\n\ndf.to_csv(\"results.csv\")\nprint(df.head(10))"
                        }
                    ]
                }
            ],
            "inputs": [
                {
                    "id": "#calculation.cwl/population",
                    "type": "File",
                    "default": {
                        "class": "File",
                        "location": "file:///home/ubuntu/sciwin_client_demo/population.csv"
                    },
                    "inputBinding": {
                        "prefix": "--population"
                    }
                },
                {
                    "id": "#calculation.cwl/speakers",
                    "type": "File",
                    "default": {
                        "class": "File",
                        "location": "file:///home/ubuntu/sciwin_client_demo/speakers.csv"
                    },
                    "inputBinding": {
                        "prefix": "--speakers"
                    }
                }
            ],
            "baseCommand": [
                "python",
                "calculation.py"
            ],
            "id": "#calculation.cwl",
            "outputs": [
                {
                    "id": "#calculation.cwl/results",
                    "type": "File",
                    "outputBinding": {
                        "glob": "results.csv"
                    }
                }
            ]
        },
        {
            "class": "Workflow",
            "inputs": [
                {
                    "id": "#main/speakers",
                    "type": "File"
                },
                {
                    "id": "#main/population",
                    "type": "File"
                }
            ],
            "outputs": [
                {
                    "id": "#main/out",
                    "type": "File",
                    "outputSource": "#main/plot/results"
                }
            ],
            "steps": [
                {
                    "id": "#main/calculation",
                    "in": [
                        {
                            "source": "#main/population",
                            "id": "#main/calculation/population"
                        },
                        {
                            "source": "#main/speakers",
                            "id": "#main/calculation/speakers"
                        }
                    ],
                    "run": "#calculation.cwl",
                    "out": [
                        "#main/calculation/results"
                    ]
                },
                {
                    "id": "#main/plot",
                    "in": [
                        {
                            "source": "#main/calculation/results",
                            "id": "#main/plot/results"
                        }
                    ],
                    "run": "#plot.cwl",
                    "out": [
                        "#main/plot/results"
                    ]
                }
            ],
            "id": "#main"
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InitialWorkDirRequirement",
                    "listing": [
                        {
                            "entryname": "plot.py",
                            "entry": "import matplotlib\nfrom matplotlib import pyplot as plt\nimport pandas as pd\nimport argparse\nimport scienceplots\nassert scienceplots, 'scienceplots needed'\nplt.style.use(['science', 'no-latex'])\n\nparser = argparse.ArgumentParser(prog=\"python plot.py\", description=\"Plots the percentage of speakers for each language\")\nparser.add_argument(\"-r\", \"--results\", required=True, help=\"Path to the results.csv File\")\nargs = parser.parse_args()\n\ndf = pd.read_csv(args.results)\ncolors = matplotlib.colormaps['tab10'](range(len(df)))\n\nax = df.plot.bar(x='language', y='percentage', legend=False, title='Language Popularity', color=colors) \nax.yaxis.set_label_text('Percentage (%)')\nax.xaxis.set_label_text('')\n\nplt.savefig('results.svg')"
                        }
                    ]
                }
            ],
            "inputs": [
                {
                    "id": "#plot.cwl/results",
                    "type": "File",
                    "default": {
                        "class": "File",
                        "location": "file:///home/ubuntu/sciwin_client_demo/results.csv"
                    },
                    "inputBinding": {
                        "prefix": "--results"
                    }
                }
            ],
            "outputs": [
                {
                    "$import": "#plot.cwl/results"
                }
            ],
            "baseCommand": [
                "python",
                "plot.py"
            ],
            "id": "#plot.cwl"
        }
    ],
    "cwlVersion": "v1.2"
}