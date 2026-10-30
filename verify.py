"""Run the positive examples and the deliberately rejected examples.

Requires Python 3 and the Lean toolchain selected by lean-toolchain.
Use: python3 verify.py (or py -3 verify.py on Windows).
"""
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
LAKE = shutil.which("lake")
if LAKE is None:
    raise SystemExit("lake was not found. Complete Lean installation first.")

def run(args):
    return subprocess.run(
        [LAKE, *args], cwd=ROOT, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        encoding="utf-8", errors="replace")

log = []
failed = False

def record(label, result, ok):
    global failed
    failed = failed or not ok
    print(f"{'PASS' if ok else 'FAIL'} {label}")
    log.append(f"=== {label} | exit {result.returncode} ===\n{result.stdout}")
    if not ok:
        print(result.stdout)

version = run(["env", "lean", "--version"])
record("Lean 4.19.0", version,
       version.returncode == 0 and "version 4.19.0," in version.stdout)
build = run(["build"])
record("project build", build,
       build.returncode == 0 and "sorryAx" not in build.stdout
       and "warning:" not in build.stdout)
if build.returncode != 0:
    (ROOT / "verification-output.txt").write_text("\n".join(log), encoding="utf-8")
    raise SystemExit(1)

expected = {
    "Intro.lean": ["3\n", "'Intro.three_waiters' does not depend on any axioms"],
    "WaitChain.lean": ["true\nfalse\n",
        "'WaitChain.chain_11_33' depends on axioms: [propext, Quot.sound]",
        "'WaitChain.wrong_witness' depends on axioms: [propext, Quot.sound]",
        "'WaitChain.cycle_11' depends on axioms: [propext, Quot.sound]"],
    "Deadlock.lean": [f"'Deadlock.{name}' does not depend on any axioms"
        for name in ("locked_stuck", "timeout_escape", "timeout_not_stuck", "second_finishes")],
    "MissingMessage.lean": [
        "'MissingMessage.absence_with_coverage' does not depend on any axioms",
        *[f"'MissingMessage.{name}' depends on axioms: [propext]" for name in
          ("conditional_case", "lossy_counterexample", "lossy_not_complete")]],
}
for filename, messages in expected.items():
    result = run(["env", "lean", filename])
    ok = (result.returncode == 0 and "warning:" not in result.stdout
          and "sorryAx" not in result.stdout
          and all(msg in result.stdout for msg in messages))
    record(filename, result, ok)

for filename, diagnostic in {
    "FalseCount.lean": "proved that the proposition",
    "FalseChain.lean": "proved that the proposition",
    "FalseDeadlock.lean": "type mismatch",
    "FalseAbsence.lean": "proved that the proposition",
}.items():
    result = run(["env", "lean", f"negative/{filename}"])
    record(f"expected rejection of {filename}", result,
           result.returncode != 0 and diagnostic in result.stdout)

(ROOT / "verification-output.txt").write_text("\n".join(log), encoding="utf-8")
print("Verification failed." if failed else "All 10 checks passed.")
sys.exit(1 if failed else 0)
