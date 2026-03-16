set -l actual (_fzfish_test_version "3.4" -gt "3.0")
set -l actual_status $status
@test "version test basic gt" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.4" -ge "3.4")
set -l actual_status $status
@test "version test basic ge equal" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.5" -ge "3.4")
set -l actual_status $status
@test "version test basic ge greater" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.4" -lt "3.5")
set -l actual_status $status
@test "version test basic lt" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.4" -le "3.4")
set -l actual_status $status
@test "version test basic le equal" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.4" -le "3.5")
set -l actual_status $status
@test "version test basic le lower" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.4" -gt "3")
set -l actual_status $status
@test "version test length not equal" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.4" -gt "3")
set -l actual_status $status
@test "version test length not equal 1" "$actual_status" = 0

_fzfish_test_version 3 -gt "3.4"
set -l actual_status $status
@test "version test length not equal 2" "$actual_status" = 1

set -l actual (_fzfish_test_version "fish 3.5.0" -gt "3.4.2")
set -l actual_status $status
@test "version test extract version left" "$actual_status" = 0

set -l actual (_fzfish_test_version "3.5.0" -gt "fish 3.4.2")
set -l actual_status $status
@test "version test extract version right" "$actual_status" = 0
