# 2023_CA_FinalProject

More details in [Implement RISC-V pipelined processor from scratch](https://hackmd.io/jQ4yP94_Sv6y85JBiH5Amw?both)

## Enviroment
```
OS   : CentOS Linux 7
Tool : Design Compiler
```

## Command

### Simulation

#### SingleCycle
```
ncverilog ./Syn/SingleCycle/top_tb.v ./Syn/SingleCycle/CPU_syn.v -v tsmc13_neg.v +define+SDF
```

#### Two-stage
```
ncverilog ./Syn/Two-stage/top_tb.v ./Syn/Two-stage/CPU_syn.v -v tsmc13_neg.v +define+SDF
```

#### Five-stage
```
ncverilog ./Syn/Five-stage/top_tb.v ./Syn/Five-stage/CPU_syn.v -v tsmc13_neg.v +define+SDF
```


## Result

CPI : Number of Instruction / Total Cycle
Performance : CPI * (1 / Cycle time)

Process: TSMC 130nm

|                    | SingleCycle CPU | Two-stage CPU | Five-stage CPU |
| ------------------ | --------------- | ------------- | -------------- |
| Cycle time (ns)    | 15              | 10            | 6              |
| Execution time(ns) | 75480           | 61640         | 43806          |
| CPI                | 1               | 0.81          | 0.68           |
| Performance        | 0.067           | 0.081         | 0.113          |
| Area               | 93209           | 99985         | 113043         |