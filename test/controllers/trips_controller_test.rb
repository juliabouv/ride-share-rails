require "test_helper"

describe TripsController do
  let (:driver) {
    Driver.create(name: "sample driver", vin: "a sample vin", active: false)
  }
  let (:passenger) {
    Passenger.create(name: "sample passenger", phone_num: "sample number")
  }
  let (:trip) {
    Trip.create(date: Date.today, rating: 4, cost: 2300, driver_id: driver.id, passenger_id: passenger.id)
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
      available_driver = driver
      
      expect {
        post passenger_trips_path(passenger.id)
      }.must_change "Trip.count", 1
      
      new_trip = Trip.first
      expect(new_trip.date).must_equal Date.today
      expect(new_trip.rating).must_be_nil
      expect(new_trip.cost).must_be_instance_of Float
      expect(new_trip.driver_id).must_equal available_driver.id
      expect(new_trip.passenger_id).must_equal passenger.id
      
      must_respond_with :redirect
      must_redirect_to trip_path(new_trip.id)
    end
    
    it "must have a driver and passenger when a trip is created" do      
      trip_hash = {
        date: Date.today,
        rating: 4,
        cost: 15.00,
        driver_id: driver.id,
        passenger_id: passenger.id
      }
      
      new_trip = Trip.create(trip_hash)
      
      expect(new_trip.driver).wont_be_nil
      expect(new_trip.passenger).wont_be_nil
    end
    
    it "if no driver is available, respond with not found error" do
      unavailable_driver = Driver.create(name: "sample driver", vin: "a sample vin", active: true)
      
      post passenger_trips_path(passenger.id)
      
      must_respond_with :not_found
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      get edit_trip_path(trip.id)
      
      must_respond_with :success
      expect(Trip.count).must_be :>, 0
    end
    
    it "responds with redirect when getting the edit page for a non-existing driver" do
      get edit_trip_path(-20)
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
  
  describe "update" do
    it "can update an existing trip accurately, and redirect" do      
      new_trip = Trip.create(date: Date.today, rating: 4, cost: 23.00, driver_id: driver.id, passenger_id: passenger.id)
      
      trip_hash = { 
        trip: { 
          date: Date.today + 1,
          rating: 1,
          cost: 10.00,
          driver_id: driver.id,
          passenger_id: passenger.id,
        }
      }
      
      expect {
        patch trip_path(new_trip.id), params: trip_hash
      }.must_differ "Trip.count", 0
      
      new_trip.reload
      
      expect(new_trip.date).must_equal trip_hash[:trip][:date]
      expect(new_trip.rating).must_equal trip_hash[:trip][:rating]
      expect(new_trip.cost).must_equal trip_hash[:trip][:cost]
      expect(new_trip.driver_id).must_equal trip_hash[:trip][:driver_id]
      expect(new_trip.passenger_id).must_equal trip_hash[:trip][:passenger_id]
      
      must_respond_with :redirect
      must_redirect_to trip_path
    end
    
    it "does not update any trip if given an invalid id, and responds with a 404" do
      trip_hash = { 
        trip: { 
          date: Date.today + 1,
          rating: 1,
          cost: 10.00,
          driver_id: 1,
          passenger_id: 1
        }
      }
      
      expect {
        patch trip_path(-20), params: trip_hash
      }.must_differ "Trip.count", 0
      
      must_respond_with :not_found
    end
  end
  
  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      id_to_delete = trip.id
      
      expect {
        delete trip_path(id_to_delete)
      }.must_differ "Trip.count", -1
      
      removed_trip = Trip.find_by(id: trip.id)
      removed_trip.must_be_nil
      
      must_respond_with :redirect
    end
    
    it "does not change the db when the trip does not exist, then responds with not found" do
      nonexistent_id = -20
      
      expect {
        delete trip_path(nonexistent_id)
      }.must_differ "Trip.count", 0
      
      must_respond_with :not_found
    end
  end
end
