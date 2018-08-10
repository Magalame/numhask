{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MonoLocalBinds     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# OPTIONS_GHC -Wall #-}

-- | Metric classes
module NumHask.Analysis.Banach
  ( Banach(..)
  , Hilbert(..)
  )
where

import NumHask.Algebra.Abstract.Action
import NumHask.Algebra.Abstract.Ring
import NumHask.Algebra.Abstract.Field
import NumHask.Analysis.Metric

-- | Banach (with Norm) laws form rules around size and direction of a number, with a potential crossing into another codomain.
--
-- > a == singleton zero || normalizeL2 a *. normL2 a == a
class (ExpField a, Normed (r a) a, DivisiveAction r a) =>
  Banach r a where
  normalizeL1 :: r a -> r a
  normalizeL1 a = a ./ normL1 a

  normalizeL2 :: r a -> r a
  normalizeL2 a = a ./ normL2 a

  normalizeLp :: a -> r a -> r a
  normalizeLp p a = a ./ normLp p a

-- | the inner product of a representable over a semiring
--
-- > a <.> b == b <.> a
-- > a <.> (b +c) == a <.> b + a <.> c
-- > a <.> (s *. b + c) == s * (a <.> b) + a <.> c
-- (s0 *. a) <.> (s1 *. b) == s0 * s1 * (a <.> b)
class (Semiring a) =>
  Hilbert r a where
  infix 8 <.>
  (<.>) :: r a -> r a -> a
