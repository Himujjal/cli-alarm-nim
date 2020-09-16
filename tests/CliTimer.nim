import unittest
# import ../src/CliTimer

suite "CLI Timer Tests":
  echo "Setting up the database"

  setup:
    echo "before each test"

  teardown:
    echo "Teardown: Run once after each test."

  test "get rows":
    assert 42 == 42

  test "delete row":
    assert 1 == 1

  test "update row":
    assert 2 == 2

  test "create row":
    assert 1 == 1

  echo "Teardown: Run once after all tests in this suite."

