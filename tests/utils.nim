import unittest
import ../src/utils

suite "CLI Utils Tests":
  echo "Setting up the database"

  setup:
    echo ""

  teardown:
    echo "Teardown: Run once after each test."

  test "get rows 1":
    assert 42 == 42

  test "delete row":
    assert 1 == 1

  test "update row":
    assert 2 == 2

  test "create row":
    assert 1 == 1

  echo "Teardown: Run once after all tests in this suite."