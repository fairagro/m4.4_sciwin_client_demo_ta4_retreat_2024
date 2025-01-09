#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

inputs:
- id: speakers
  type: File
- id: population
  type: File

outputs:
- id: out
  type: File
  outputSource: plot/results

steps:
- id: calculation
  in:
    speakers: speakers
    population: population
  run: '../calculation/calculation.cwl'
  out:
  - results
- id: plot
  in:
    results: calculation/results
  run: '../plot/plot.cwl'
  out:
  - results
