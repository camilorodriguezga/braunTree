module Data.stlib.bt-negation where

open import Data.stlib.bt-level
open import Data.stlib.bt-empty

----------------------------------------------------------------------
-- syntax
----------------------------------------------------------------------

infix 7 ¬_

----------------------------------------------------------------------
-- defined types
----------------------------------------------------------------------

¬_ : ∀{ℓ}(x : Set ℓ) → Set ℓ
¬ x = x → ⊥