import Intro

-- Expected rejection: there are three waiters, not four.
example : Intro.waiters.length = 4 := by decide
