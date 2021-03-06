
module test.bt-example-test where

open import Data.stlib.bt-nat
open import Data.stlib.bt-list
open import Data.stlib.bt-product
open import Data.stlib.bt-sum
open import Data.stlib.bt-eq

import Data.braun-tree

open Data.braun-tree ℕ _<_

data₁ : BraunTree 0
data₁ = btEmpty

data₂ : BraunTree 1
data₂ = btNode 1
               btEmpty
               btEmpty
               (inj₁ refl)

data₃ : BraunTree 2
data₃ = btNode 200
               (btNode 1000
                 btEmpty
                 btEmpty
                 (inj₁ refl))
               btEmpty
               (inj₂ refl)
               
data₄ : BraunTree 4
data₄ = btNode 2 
               (btNode 3
                        (btNode 20000
                                 btEmpty
                                 btEmpty
                                 (inj₁ refl))
                        btEmpty
                        (inj₂ refl))
               (btNode 1
                        btEmpty
                        btEmpty
                        (inj₁ refl))
               (inj₂ refl)

insert₁ : BraunTree 2
insert₁ = btInsert 100
                 (btInsert 1 btEmpty) 

insert₂ : BraunTree 1
insert₂ = btInsert 0
                 btEmpty
                 
removeMin₁ : BraunTree 0
removeMin₁ = btDeleteMin data₂

removeMin₂ : BraunTree 1
removeMin₂ = btDeleteMin data₃

replace₁ : BraunTree 2
replace₁ = btReplaceMin 100 data₃ 
