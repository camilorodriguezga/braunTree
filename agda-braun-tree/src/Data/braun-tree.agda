open import Data.stlib.bt-bool

module Data.braun-tree{ℓ} (A : Set ℓ) (_<A_ : A → A → 𝔹) where

open import Data.stlib.bt-bool-thms
open import Data.stlib.bt-eq
open import Data.stlib.bt-nat
open import Data.stlib.bt-nat-thms
open import Data.stlib.bt-product
open import Data.stlib.bt-sum

-- the index n is the size of the tree (number of elements of type A)
data BraunTree : (n : ℕ) → Set ℓ where
  btEmpty : BraunTree 0
  btNode  : ∀ {m n : ℕ} → 
            A → BraunTree m → BraunTree n → 
            m ≡ n ∨ m ≡ suc n → 
            BraunTree (suc (m + n))


{- we will keep smaller (_<A_) elements closer to the root of the Braun tree as we insert -}
btInsert : ∀ {n : ℕ} → A → BraunTree n → BraunTree (suc n)

btInsert a btEmpty = btNode a btEmpty btEmpty (inj₁ refl)

btInsert a (btNode{n}{m} a' l r p) 
  rewrite +comm n m with p | if a <A a' then (a , a') else (a' , a)
btInsert a (btNode{n}{m} a' l r _) | inj₁ p | (a1 , a2) 
  rewrite p = (btNode a1 (btInsert a2 r) l (inj₂ refl))
btInsert a (btNode{n}{m} a' l r _) | inj₂ p | (a1 , a2) = 
  (btNode a1 (btInsert a2 r) l (inj₁ (sym p)))


btReplaceMin : ∀{n : ℕ} → A → BraunTree (suc n) → BraunTree (suc n)
btReplaceMin a (btNode _ btEmpty btEmpty u) = (btNode a btEmpty btEmpty u)
btReplaceMin a (btNode _ btEmpty (btNode _ _ _ _) (inj₁ ()))
btReplaceMin a (btNode _ btEmpty (btNode _ _ _ _) (inj₂ ()))
btReplaceMin a (btNode _ (btNode _ _ _ _) btEmpty (inj₁ ()))
btReplaceMin a (btNode a' (btNode x l r u) btEmpty (inj₂ y)) with a <A x
btReplaceMin a (btNode a' (btNode x l r u) btEmpty (inj₂ y)) | tt = (btNode a (btNode x l r u) btEmpty (inj₂ y))
btReplaceMin a (btNode a' (btNode x l r u) btEmpty (inj₂ y)) | ff = 
 (btNode x (btReplaceMin a (btNode x l r u)) btEmpty (inj₂ y))
btReplaceMin a (btNode a' (btNode x l r u) (btNode x' l' r' u') v) with a <A x && a <A x' 
btReplaceMin a (btNode a' (btNode x l r u) (btNode x' l' r' u') v) | tt = 
 (btNode a (btNode x l r u) (btNode x' l' r' u') v)
btReplaceMin a (btNode a' (btNode x l r u) (btNode x' l' r' u') v) | ff with x <A x'  
btReplaceMin a (btNode a' (btNode x l r u) (btNode x' l' r' u') v) | ff | tt = 
 (btNode x (btReplaceMin a (btNode x l r u)) (btNode x' l' r' u') v)
btReplaceMin a (btNode a' (btNode x l r u) (btNode x' l' r' u') v) | ff | ff = 
 (btNode x' (btNode x l r u) (btReplaceMin a (btNode x' l' r' u')) v)
 

{- thanks to Matías Giovannini for the excellent post
     http://alaska-kamtchatka.blogspot.com/2010/02/braun-trees.html
   explaining how to do delete -}
btDeleteMin : ∀ {p : ℕ} → BraunTree (suc p) → BraunTree p
btDeleteMin (btNode a btEmpty btEmpty u) = btEmpty
btDeleteMin (btNode a btEmpty (btNode _ _ _ _) (inj₁ ()))
btDeleteMin (btNode a btEmpty (btNode _ _ _ _) (inj₂ ()))
btDeleteMin (btNode a (btNode{m'}{n'} a' l' r' u') btEmpty u) rewrite +0 (m' + n') = btNode a' l' r' u'
btDeleteMin (btNode a
                (btNode{m}{n} x l1 r1 u1)
                (btNode{m'}{n'} x' l2 r2 u2) u) 
  rewrite +suc(m + n)(m' + n') | +suc m (n + (m' + n')) 
        | +comm(m + n)(m' + n') = 
  if (x <A x') then
    (btNode x (btNode x' l2 r2 u2)
      (btDeleteMin (btNode x l1 r1 u1)) (lem{m}{n}{m'}{n'} u))
  else
    (btNode x' (btReplaceMin x (btNode x' l2 r2 u2))
      (btDeleteMin (btNode x l1 r1 u1)) (lem{m}{n}{m'}{n'} u))
  where lem : {m n m' n' : ℕ} → suc (m + n) ≡ suc (m' + n') ∨ suc (m + n) ≡ suc (suc (m' + n')) → 
              suc (m' + n') ≡ m + n ∨ suc (m' + n') ≡ suc (m + n)
        lem{m}{n}{m'}{n'} (inj₁ x) = inj₂ (sym x)
        lem (inj₂ y) = inj₁ (sym (suc-inj y))

btRemoveMin : ∀ {p : ℕ} → BraunTree (suc p) → A × BraunTree p
btRemoveMin (btNode a l r u) = a , btDeleteMin (btNode a l r u)
