import Deadlock

-- Expected rejection: the theorem is for disabled timeouts.
example : Deadlock.Stuck true Deadlock.locked := by
  exact Deadlock.locked_stuck
