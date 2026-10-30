import Std

namespace MissingMessage

inductive Event where
  | start (request : Nat)
  | finish (request : Nat)
  deriving Repr, DecidableEq

-- Both traces describe the same fixed observation window.
def CompleteFor (actual observed : List Event) (r : Nat) : Prop :=
  Event.finish r ∈ actual → Event.finish r ∈ observed

theorem absence_with_coverage (actual observed : List Event)
    (r : Nat) (coverage : CompleteFor actual observed r)
    (absent : Event.finish r ∉ observed) :
    Event.finish r ∉ actual := by
  intro occurred
  exact absent (coverage occurred)

def captured : List Event := [.start 7, .start 8, .finish 8]

theorem missing_7 : Event.finish 7 ∉ captured := by
  decide

theorem conditional_case (actual : List Event)
    (coverage : CompleteFor actual captured 7) :
    Event.finish 7 ∉ actual := by
  exact absence_with_coverage actual captured 7 coverage missing_7

def actualLossy : List Event := [.start 7, .finish 7]
def observedLossy : List Event := [.start 7]

theorem lossy_counterexample :
    Event.finish 7 ∉ observedLossy ∧
    Event.finish 7 ∈ actualLossy := by
  decide

theorem lossy_not_complete :
    ¬ CompleteFor actualLossy observedLossy 7 := by
  intro coverage
  have recorded := coverage (by decide)
  have absent : Event.finish 7 ∉ observedLossy := by decide
  exact absent recorded

#print axioms absence_with_coverage
#print axioms conditional_case
#print axioms lossy_counterexample
#print axioms lossy_not_complete

end MissingMessage
