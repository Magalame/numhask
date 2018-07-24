{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MonoLocalBinds #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wall #-}

-- | Ring
module NumHask.Algebra.Abstract.Ring
  ( Distributive
  , Semiring
  , Ring
  , CommutativeRing
  , IntegralDomain
  , StarSemiring(..)
  , KleeneAlgebra
  , InvolutiveRing(..)
  )
where

import Data.Int (Int8, Int16, Int32, Int64)
import Data.Word (Word, Word8, Word16, Word32, Word64)
import GHC.Natural (Natural(..))
import NumHask.Algebra.Abstract.Additive
import NumHask.Algebra.Abstract.Group
import NumHask.Algebra.Abstract.Multiplicative
import qualified Prelude as P

-- | Distributive  laws
--
-- > a * (b + c) == a * b + a * c
-- > (a * b) * c == a * c + b * c
class (Additive a, Multiplicative a) =>
  Distributive a

instance Distributive P.Double

instance Distributive P.Float

instance Distributive P.Int
instance Distributive P.Integer
instance Distributive Natural
instance Distributive Int8
instance Distributive Int16
instance Distributive Int32
instance Distributive Int64
instance Distributive Word
instance Distributive Word8
instance Distributive Word16
instance Distributive Word32
instance Distributive Word64

instance Distributive P.Bool

instance Distributive b => Distributive (a -> b)

-- | Semiring
-- TODO: rule zero' = zero. Is this somehow expressible in haskell?
class (Associative (Sum a), Unital (Sum a), Associative (Product a),
       Unital (Product a), Distributive a) =>
  Semiring a where
instance (Associative (Sum a), Unital (Sum a), Associative (Product a),
          Unital (Product a), Distributive a) =>
  Semiring a

-- | Ring
class (Semiring a, AbelianGroup (Sum a)) =>
  Ring a
instance (Semiring a, AbelianGroup (Sum a)) =>
  Ring a

-- | Ring with a commutative Multiplication
class (Ring a, Commutative (Product a)) =>
  CommutativeRing a
instance (Ring a, Commutative (Product a)) =>
  CommutativeRing a

-- | generalization of ring of integers
--  rules:
--  product of any two nonzero elements is nonzero, also
--  if a ≠ 0, an equality ab = ac implies b = c.
--  this essentially is a generalization of division and a fundamental step towards a Field
class (CommutativeRing a, Invertible (Product a)) =>
  IntegralDomain a

instance IntegralDomain P.Double

instance IntegralDomain P.Float

instance IntegralDomain b => IntegralDomain (a -> b)

-- | StarSemiring
--
-- > star a = one + a `times` star a
--
class (Semiring a) => StarSemiring a where
  star :: a -> a
  star a = one + plus a

  plus :: a -> a
  plus a = a * star a

instance StarSemiring b => StarSemiring (a -> b)

-- | KleeneAlgebra
--
-- > a `times` x + x = a ==> star a `times` x + x = x
-- > x `times` a + x = a ==> x `times` star a + x = x
--
class (StarSemiring a, Idempotent (Sum a)) => KleeneAlgebra a

instance KleeneAlgebra b => KleeneAlgebra (a -> b)

-- | Involutive Ring
--
-- > adj (a + b) ==> adj a + adj b
-- > adj (a * b) ==> adj a * adj b
-- > adj one ==> one
-- > adj (adj a) ==> a
--
-- Note: elements for which @adj a == a@ are called "self-adjoint".
--
class Semiring a => InvolutiveRing a where
  adj :: a -> a
  adj x = x

instance InvolutiveRing P.Double

instance InvolutiveRing P.Float

instance InvolutiveRing P.Integer

instance InvolutiveRing P.Int

instance InvolutiveRing Natural

instance InvolutiveRing Int8

instance InvolutiveRing Int16

instance InvolutiveRing Int32

instance InvolutiveRing Int64

instance InvolutiveRing Word

instance InvolutiveRing Word8

instance InvolutiveRing Word16

instance InvolutiveRing Word32

instance InvolutiveRing Word64

instance InvolutiveRing b => InvolutiveRing (a -> b)