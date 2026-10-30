import Std

namespace WaitChain

abbrev Edges := List (Nat × Nat)

inductive Reaches (es : Edges) : Nat → Nat → Prop where
  | one {a b} : (a, b) ∈ es → Reaches es a b
  | more {a b c} : (a, b) ∈ es →
      Reaches es b c → Reaches es a c

def TwoStep (es : Edges) (a b c : Nat) : Prop :=
  (a, b) ∈ es ∧ (b, c) ∈ es

theorem twoStep_reaches (es : Edges) (a b c : Nat)
    (h : TwoStep es a b c) : Reaches es a c := by
  exact Reaches.more h.1 (Reaches.one h.2)

def captured : Edges := [(11, 22), (22, 33)]

#eval captured.contains (11, 22)
#eval captured.contains (22, 44)

theorem chain_11_33 : Reaches captured 11 33 := by
  exact twoStep_reaches captured 11 22 33 (by
    unfold TwoStep
    decide)

theorem wrong_witness : ¬ TwoStep captured 11 22 44 := by
  unfold TwoStep
  decide

def cyclic : Edges := [(11, 22), (22, 33), (33, 11)]

theorem cycle_11 : Reaches cyclic 11 11 := by
  exact Reaches.more (b := 22) (by decide)
    (Reaches.more (b := 33) (by decide)
      (Reaches.one (by decide)))

#print axioms chain_11_33
#print axioms wrong_witness
#print axioms cycle_11

end WaitChain
