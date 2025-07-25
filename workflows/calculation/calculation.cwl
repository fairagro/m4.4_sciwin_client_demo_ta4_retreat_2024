#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements:
- class: InitialWorkDirRequirement
  listing:
  - entryname: calculation.py
    entry:
      $include: ../../calculation.py

inputs:
- id: population
  type: File
  default:
    class: File
    location: ../../population.csv
  inputBinding:
    prefix: --population
- id: speakers
  type: File
  default:
    class: File
    location: ../../speakers.csv
  inputBinding:
    prefix: --speakers

outputs:
- id: results
  type: File
  outputBinding:
    glob: results.csv

baseCommand:
- python
- calculation.py
