# FIFO Verification

Verilog FIFO designs with SystemVerilog verification environments.

| Design | RTL | Testbench |
|---|---|---|
| Synchronous FIFO (`sync_fifo/`) | Done | In progress |
| Asynchronous FIFO (`async_fifo/`) | Done | Planned |

## Synchronous FIFO

- Parameterized: 8-bit data width, 32 entries (default)
- Counter-based full/empty tracking
- Registered read output

### Verification environment (class-based, constrained-random)

```
 Generator --> Driver --> DUT --> Monitor --> Scoreboard
    (mailbox)                        (mailbox)
```

Components:
- [ ] Interface (clock, reset, DUT signals)
- [ ] Transaction class (randomized write/read enable and data)
- [ ] Generator (creates randomized transactions)
- [ ] Driver (drives transactions onto the DUT interface)
- [ ] Monitor (samples DUT inputs and outputs)
- [ ] Scoreboard (compares DUT output against a reference queue)
- [ ] Environment class connecting everything through mailboxes
- [ ] Top-level testbench (clock, reset, DUT instance)

Scenarios:
- [ ] Reset behavior
- [ ] Write until full, extra writes ignored
- [ ] Read until empty, extra reads ignored
- [ ] Simultaneous read and write
- [ ] Pointer wraparound
- [ ] Constrained-random regression

Checks and coverage:
- [ ] Assertion: no write accepted when full
- [ ] Assertion: no read accepted when empty
- [ ] Functional coverage (full, empty, wraparound, simultaneous read/write)

## Asynchronous FIFO

- Separate write and read clocks
- Gray-code read/write pointers (one bit changes per increment)
- 2-flop synchronizers move each pointer into the other clock domain
- Empty: read gray pointer equals synchronized write pointer (read domain)
- Full: top two gray bits differ and remaining bits match the synchronized read pointer (write domain)
- Extra pointer bit distinguishes full from empty

Testbench (planned):
- [ ] Dual-clock setup with unrelated clock ratios (for example 10 ns / 7 ns)
- [ ] Fast write / slow read
- [ ] Slow write / fast read
- [ ] Write until full, read until empty
- [ ] Pointer wraparound (at least two laps)
- [ ] Scoreboard checking data order
- [ ] Assertion: gray pointer changes by at most one bit per clock
- [ ] Functional coverage

## Repository structure

```
fifo-verification/
├── sync_fifo/
│   ├── fifo.v
│   └── tb/
├── async_fifo/
│   └── fifo_async.v
└── README.md
```

## How to run

```
<simulator command you use>
```

Waveforms viewed in GTKWave / Vivado.

## Tools

Verilog, SystemVerilog, <simulator>, GTKWave

