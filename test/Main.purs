module Test.Main where

import Prelude (Unit, ($), (==), bind)

import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Console(TESTOUTPUT)
import Test.Unit.Assert(assert)

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar(AVAR)


main :: forall t1.
      Eff
        ( console :: CONSOLE
        , testOutput :: TESTOUTPUT
        , avar :: AVAR
        | t1
        )
        Unit
main = runTest do
  suite "aws support" do
    test "should create OAI" do
      assert "it does not work" false
