# LeanPOD

**Using Lean in Pattern-Oriented Diagnostics**  
Dmitry Vostokov | [DumpAnalysis.org](https://DumpAnalysis.org)

This repository contains the reproducible examples accompanying my article
*Using Lean in Pattern-Oriented Diagnostics*. I use Lean to make diagnostic
assumptions explicit and check what follows from them.

The examples are constructed teaching cases. Their proofs concern the supplied
models; they do not establish the accuracy of evidence extracted from a live
system.

## Examples

| File | Experiment |
| --- | --- |
| [`Intro.lean`](Intro.lean) | An introductory calculation and a checked proposition. |
| [`WaitChain.lean`](WaitChain.lean) | Paths, an invalid witness, and a cycle in supplied wait-for edges. |
| [`Deadlock.lean`](Deadlock.lean) | A restricted two-thread transition model and a possible timeout escape. |
| [`MissingMessage.lean`](MissingMessage.lean) | Absence under an explicit coverage assumption, with a lossy-observation counterexample. |

## Run the examples

Complete the [Lean installation](https://lean-lang.org/install/) first. The
project pins **Lean 4.19.0**, the tested baseline. It requires no Mathlib or other
third-party Lean dependencies.

From the repository directory:

```sh
elan toolchain install leanprover/lean4:v4.19.0
lake env lean --version
lake build

lake env lean Intro.lean
lake env lean WaitChain.lean
lake env lean Deadlock.lean
lake env lean MissingMessage.lean
```

`Intro.lean` prints `3`; `WaitChain.lean` prints `true` and then `false`.
All four files also display theorem axiom reports.

With Python 3 installed, run the complete verification:

```sh
python3 verify.py
```

On Windows, use `py -3 verify.py`. The expected final line is
`All 10 checks passed.` The script checks the toolchain version, project build,
four positive files, and four deliberate rejections. It rewrites
`verification-output.txt` with the current run's output.

## Deliberately rejected proofs

The four files in [`negative/`](negative/) must fail with their expected
diagnostics. They are excluded from the normal build. Run `lake build` before
running them individually, because they import the positive examples.

A missing compiler or import is not a successful negative test. The verification
script checks relevant diagnostic messages as well as exit codes. An arbitrary
proof failure does not prove the negation of a proposition.

## Try changing the evidence or assumptions

- Remove `(33, 11)` from `cyclic` in `WaitChain.lean` and observe the old cycle
  certificate fail.
- Change the transition constructors in `Deadlock.lean` and examine which
  proofs need to account for the new possibilities. A possible timeout escape
  does not establish that the scheduler will eventually choose it.
- Compare `actualLossy` and `observedLossy` in `MissingMessage.lean`. An event
  missing from an observation may still have occurred in the actual history.

## Reviewed companion and validation record

The 18 files from **companion archive Version 2, dated 28 October 2026**, are
preserved unchanged. This repository adds this Markdown overview and a
`.gitignore` for generated files.

See [`README.txt`](README.txt) for the complete original instructions,
[`VALIDATION.txt`](VALIDATION.txt) for the original execution record and its
environment-specific compatibility shim, and
[`verification-output.txt`](verification-output.txt) for the captured output.
Normal Lean installations do not need the shim.

[`SHA256SUMS.txt`](SHA256SUMS.txt) covers the other 17 original companion files.
It does not cover this Markdown overview or `.gitignore`. Running verification
changes the captured output file, so check the original hashes before running it.

The project does not implement debugger extraction, WinDbg or Prolog integration,
capture-coverage measurement, or a complete diagnostic report schema.
