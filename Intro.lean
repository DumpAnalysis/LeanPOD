import Std

namespace Intro

def waiters : List Nat := [11, 22, 33]

#eval waiters.length

theorem three_waiters : waiters.length = 3 := by
  decide

theorem member_of_evidence (xs : List Nat) (n : Nat)
    (h : n ∈ xs) : n ∈ xs := by
  exact h

#print axioms three_waiters

end Intro
