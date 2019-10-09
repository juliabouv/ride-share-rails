require "test_helper"

describe TripsController do
  let (:driver) {
    Driver.create(name: "sample driver", vin: "a sample vin", active: false)
  }
  let (:passenger) {
    Passenger.create(name: "sample passenger", phone_num: "sample number")
  }
  let (:trip) {
    Trip.create date: Date.today, rating: 4, cost: 23.00, driver_id: driver.id, passenger_id: passenger.id
  }
  describe "show" do
    it "can get a valid trip" do
      get trip_path(trip.id)
      
      must_respond_with :success
    end
    
    it "will redirect for an invalid trip" do
      get trip_path(-1)
      
      must_respond_with :redirect
    end
  end
  
  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      new_pass = Passenger.create(name: "sample passenger", phone_num: "sample number")
      new_driver = Driver.create(name: "sample driver", vin: "a sample vin", active: false)
      
      
      expect {
        post passenger_trips_path(new_pass.id)
      }.must_change "Trip.count", 1
      
      new_trip = Trip.first
      expect(new_trip.date).must_equal Date.today
      expect(new_trip.rating).must_be_nil
      expect(new_trip.cost).must_equal 13.00
      expect(new_trip.driver_id).must_equal new_driver.id
      expect(new_trip.passenger_id).must_equal new_pass.id
      
      must_respond_with :redirect
      must_redirect_to trip_path(new_trip.id)
    end
    
    it "must have a driver and passenger when a trip is created" do
      new_pass = Passenger.create(name: "sample passenger", phone_num: "sample number")
      new_driver = Driver.create(name: "sample driver", vin: "a sample vin", active: false)
      
      trip_hash = {
        date: Date.today,
        rating: 4,
        cost: 15.00,
        driver_id: new_driver.id,
        passenger_id: new_pass.id
      }
      
      new_trip = Trip.create(trip_hash)
      
      expect(new_trip.driver).wont_be_nil
      expect(new_trip.passenger).wont_be_nil
    end
    
    
  end
  
  describe "edit" do
    it "" do
      # Your tests go here
    end
  end
  
  describe "update" do
    it "" do
      # Your tests go here
    end
  end
  
  describe "destroy" do
    it "" do
      # Your tests go here
    end
  end
end
