require "rails_helper"

describe AuctionStatus do
  describe "#available?" do
    context "start datetime in past, end datetime in future" do
      it "is true" do
        auction = FactoryGirl.build(:auction, started_at: yesterday, ended_at: tomorrow)

        status = AuctionStatus.new(auction)

        expect(status).to be_available
      end

      context "start datetime in past, end datetime in past" do
        it "is false" do
          auction = FactoryGirl.build(:auction, started_at: yesterday, ended_at: yesterday)

          status = AuctionStatus.new(auction)

          expect(status).not_to be_available
        end
      end

      context "start datetime in future, end datetime in future" do
        it "is false" do
          auction = FactoryGirl.build(:auction, started_at: tomorrow, ended_at: tomorrow)

          status = AuctionStatus.new(auction)

          expect(status).not_to be_available
        end
      end
    end

    describe "#over?" do
      context "end datetime is in past" do
        it "is true" do
          auction = FactoryGirl.build(:auction, ended_at: yesterday)

          status = AuctionStatus.new(auction)

          expect(status).to be_over
        end
      end

      context "end datetime is in future" do
        it "is false" do
          auction = FactoryGirl.build(:auction, ended_at: tomorrow)

          status = AuctionStatus.new(auction)

          expect(status).not_to be_over
        end
      end

      context "end datetime is nil" do
        it "is false" do
          auction = FactoryGirl.build(:auction, ended_at: nil)

          status = AuctionStatus.new(auction)

          expect(status).not_to be_over
        end
      end
    end

    describe "#future?" do
      context "start datetime is in future" do
        it "is true" do
          auction = FactoryGirl.build(:auction, started_at: tomorrow)

          status = AuctionStatus.new(auction)

          expect(status).to be_future
        end
      end

      context "start datetime is in past" do
        it "is false" do
          auction = FactoryGirl.build(:auction, started_at: yesterday)

          status = AuctionStatus.new(auction)

          expect(status).not_to be_future
        end
      end

      context "start datetime is nil" do
        it "is true" do
          auction = FactoryGirl.build(:auction, started_at: nil)

          status = AuctionStatus.new(auction)

          expect(status).to be_future
        end
      end
    end

    describe "expiring?" do
      context "auction in progress and expiring in less than 12 hours" do
        it "is true" do
          auction = FactoryGirl.build(
            :auction,
            started_at: yesterday,
            ended_at: one_hour_from_now
          )

          status = AuctionStatus.new(auction)

          expect(status).to be_expiring
        end
      end

      context "auction not started and expiring in less than 12 hours" do
        it "is false" do
          auction = FactoryGirl.build(
            :auction,
            started_at: tomorrow,
            ended_at: one_hour_from_now
          )

          status = AuctionStatus.new(auction)

          expect(status).not_to be_expiring
        end
      end

      context "auction in progress and expiring in more than 12 hours" do
        it "is false" do
          auction = FactoryGirl.build(
            :auction,
            started_at: yesterday,
            ended_at: tomorrow
          )

          status = AuctionStatus.new(auction)

          expect(status).not_to be_expiring
        end
      end
    end

    def yesterday
      @_yesterday ||= Time.current - 1.day
    end

    def tomorrow
      @_tomorrow ||= Time.current + 1.day
    end

    def one_hour_from_now
      @_one_hour_from_now ||= Time.current + 1.hour
    end
  end
end
