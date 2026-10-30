Using Lean in Pattern-Oriented Diagnostics
Dmitry Vostokov | DumpAnalysis.org
Archive Version 2 | 28 October 2026

This project accompanies the article of the same title. Its three diagnostic
examples and one introductory file are self-contained. They retain import Std
for consistency, although everything used is available in the implicitly imported
Init prelude; the examples also check with that import removed.
They are constructed teaching cases, not a WinDbg or Prolog integration.

SETUP

1. Follow https://lean-lang.org/install/ and finish the Lean 4 VS Code setup.
2. Extract this directory and open it as the project folder in VS Code.
3. Open a new terminal in this directory.
4. Run:

   elan toolchain install leanprover/lean4:v4.19.0
   lake env lean --version
   lake build

The selected version must be 4.19.0. This fixed version is the tested baseline,
not a claim to be the latest release. The bundled standard library is sufficient.
There are no third-party Lean dependencies. Initial installation requires internet.

REPLAY INDIVIDUAL EXAMPLES

   lake env lean Intro.lean
   lake env lean WaitChain.lean
   lake env lean Deadlock.lean
   lake env lean MissingMessage.lean

Intro prints 3. WaitChain prints true then false. All four files also display
axiom reports. The expected reports are retained in verification-output.txt.
Normal builds can be cached; the commands above replay the displayed output.

EXPECTED REJECTIONS

These commands intentionally return nonzero status. They must not be added to
the normal build. Each supplies a deliberately incorrect proof attempt:

   lake env lean negative/FalseCount.lean
   lake env lean negative/FalseChain.lean
   lake env lean negative/FalseDeadlock.lean
   lake env lean negative/FalseAbsence.lean

The first, second, and fourth fail because decide establishes that the proposed
proposition is false. FalseDeadlock fails because a theorem for disabled timeouts
does not have the type required for enabled timeouts. A generic proof failure
does not itself prove negation. The positive files include the actual relevant
refutations and counterexamples.

OPTIONAL AUTOMATED VERIFICATION

Install Python 3 if needed, then run:

   python3 verify.py

On Windows:

   py -3 verify.py

Expected final line: All 10 checks passed.
The script checks the version, build, four positive files, and four expected
rejections. It checks relevant messages as well as exit codes and rewrites
verification-output.txt with the latest output. Read diagnostic messages if a
check fails. Do not treat a missing compiler or missing import as a successful
negative test.

EXPERIMENTS

Make copies before experimenting. Remove (33, 11) from cyclic in WaitChain.lean:
the old cycle certificate fails. Add a missing edge and update the appropriate
negative statement: the valid and invalid cases change with the data.

Change the transition constructors in Deadlock.lean: the proof must cover the
new possibilities. Enabling a timeout proves an escape is possible; it does not
prove a scheduler will eventually choose it.

In MissingMessage.lean, compare actualLossy with observedLossy. Removing an event
from an observation does not remove it from the actual history. The conditional
inference requires coverage for the relevant event and observation window.

SCOPE

WaitChain proves paths in supplied edge lists. It does not establish the accuracy
of a debugger's extraction. Deadlock proves a restricted two-thread state-machine
property. MissingMessage proves a conditional result and a lossy counterexample.
No translation between these teaching models, live-system integration, coverage
measurement, or full diagnostic report schema is implemented in this project.

VALIDATION

See VALIDATION.txt for the original run and environment details. The validation
directory contains the process-path compatibility shim source used only in the
original execution environment; normal Lean installations do not need it.
SHA256SUMS.txt identifies the distributed source and configuration files.

Archive Version 2 updates this README and its checksum. The Lean sources,
verification script, captured output and original validation record are unchanged.
