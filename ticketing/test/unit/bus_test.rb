require 'test_helper'
require 'ruby-debug'

class BusTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "Status should be one of 'Open' or 'Locked'" do
    b = buses(:valid)

    b.status = nil
    assert b.invalid?, "Blank status should not be accepted"
    b.save
    assert b.errors.invalid?(:status), "There should be an error in the status for a blank status"

    b.status = :open
    assert b.valid?, "'Open' should be accepted as a status: " + b.errors.full_messages.inspect

    b.status = :locked
    assert b.valid?, "'Locked should be accepted as a status"

    b.status = :moo
    assert b.invalid?, "'Moo' should be an invalid status"
    b.save
    assert b.errors.invalid?(:status), "'Moo' as a status should cause a status error"
  end

  test "Departure, arrival, and return date/times should be valid" do

    valid_times = ["2010-01-01 00:00", "2010-01-01 00:59", "2010-01-01 13:00:59"]
    invalid_times = ["25:00:00", "00:60", "13:00pm", "", nil, "sdfaw", "5 o'clock"]

    valid_times.each do |time|
      b = buses(:valid).clone

      b.departure = time
      assert b.valid?, time.to_s + ' should be accepted as a valid time for departure'

      b.arrival = time
      assert b.valid?, time.to_s + ' should be accepted as a valid time for arrival'

      b.return = time
      assert b.valid?, time.to_s + ' should be accepted as a valid time for return'
    end

    invalid_times.each do |time|
      b = buses(:valid).clone

      b.departure = time
      assert b.invalid?, time.to_s + ' should not be accepted as a valid time for departure'
      assert b.errors.invalid?(:departure), 'There should be an error in the departure for ' + time.to_s

      b.arrival = time
      assert b.invalid?, time.to_s + ' should not be accepted as a valid time for arrival'
      assert b.errors.invalid?(:arrival), 'There should be an error in the arrival for ' + time.to_s

      b.return = time
      assert b.invalid?, time.to_s + ' should not be accepted as a valid time for return'
      assert b.errors.invalid?(:return), 'There should be an error in the return for ' + time.to_s
    end

  end

  test "Bus should either go from Waterloo, to Waterloo, or both" do
    b = buses(:valid)

    b.direction = nil
    assert b.invalid?, "Bus should not allow nil direction"

    b.direction = :foobar
    assert b.invalid?, "Bus should not accept random symbol for direction"

    b.direction = :to_waterloo
    assert b.valid?

    b.direction = :from_waterloo
    assert b.valid?

    b.direction = :both_directions
    assert b.valid?
  end

  test "Bus requires a name" do
    b = buses(:valid)

    b.name = nil
    assert b.invalid?, "Bus should not accept a nil name"
    assert b.errors.invalid?(:name), 'A nil name should cause an error'

    b.name = ""
    assert b.invalid?, "Bus should not accept a blank name"
    assert b.errors.invalid?(:name), 'A blank name should cause an error'


    b.name = 'Something'
    assert b.valid?, "Bus should accept any name"
  end

  test "Bus maximum seats should be zero or greater" do
    b = buses(:valid)
    b.maximum_seats = -2
    assert b.invalid?
    assert b.errors.invalid?(:maximum_seats)

    b.maximum_seats = "foobar!"
    assert b.invalid?
    assert b.errors.invalid?(:maximum_seats)

    b.maximum_seats = 0
    assert b.valid?

    b.maximum_seats = 48
    assert b.valid?
  end
end
