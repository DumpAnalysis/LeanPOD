import WaitChain

-- Expected rejection: the edge (22, 44) is missing.
example : WaitChain.TwoStep WaitChain.captured 11 22 44 := by
  unfold WaitChain.TwoStep
  decide
