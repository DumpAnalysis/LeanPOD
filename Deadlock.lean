import Std

namespace Deadlock

structure State where
  aHeld : Bool
  bHeld : Bool
  pending1 : Bool
  pending2 : Bool
  deriving Repr, DecidableEq

-- T1 owns A and requests B. T2 owns B and requests A.
-- A finish step acquires the free requested lock,
-- completes the operation, and releases both locks.
inductive Step (timeouts : Bool) : State → State → Prop where
  | finish1 {s} : s.pending1 = true → s.bHeld = false →
      Step timeouts s {s with aHeld := false, pending1 := false}
  | finish2 {s} : s.pending2 = true → s.aHeld = false →
      Step timeouts s {s with bHeld := false, pending2 := false}
  | abort1 {s} : timeouts = true → s.pending1 = true →
      Step timeouts s {s with aHeld := false, pending1 := false}

def Stuck (timeouts : Bool) (s : State) : Prop :=
  (s.pending1 = true ∨ s.pending2 = true) ∧
  ∀ next, ¬ Step timeouts s next

def locked : State := ⟨true, true, true, true⟩

theorem locked_stuck : Stuck false locked := by
  constructor
  · exact Or.inl rfl
  · intro next h
    cases h with
    | finish1 hp hb => cases hb
    | finish2 hp ha => cases ha
    | abort1 ht hp => cases ht

def escaped : State := ⟨false, true, false, true⟩

theorem timeout_escape : Step true locked escaped := by
  exact Step.abort1 rfl rfl

theorem timeout_not_stuck : ¬ Stuck true locked := by
  intro h
  exact h.2 escaped timeout_escape

def finished : State := ⟨false, false, false, false⟩

theorem second_finishes : Step true escaped finished := by
  exact Step.finish2 rfl rfl

#print axioms locked_stuck
#print axioms timeout_escape
#print axioms timeout_not_stuck
#print axioms second_finishes

end Deadlock
