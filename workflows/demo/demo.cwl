#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

inputs:
- id: speakers
  type: File
- id: pop
  type: File

outputs:
- id: out
  type: File
  outputSource: plot/o_results

steps:
- id: calculation
  in:
  - id: speakers
    source: speakers
  - id: population
    source: pop
  run: ../calculation/calculation.cwl
  out:
  - results
- id: plot
  in:
  - id: results
    source: calculation/results
  run: ../plot/plot.cwl
  out:
  - o_results
