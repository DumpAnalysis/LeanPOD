import MissingMessage

-- Expected rejection: the actual trace contains the finish event.
example : MissingMessage.Event.finish 7 ∉
    MissingMessage.actualLossy := by decide
