require "./spec_helper"

def card_hash
  {"title" => "Fake", "body" => "Fake"}
end

def card_params
  params = [] of String
  params << "title=#{card_hash["title"]}"
  params << "body=#{card_hash["body"]}"
  params.join("&")
end

def create_card
  model = Card.new(card_hash)
  model.save
  model
end

class CardControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
    end
    @handler.prepare_pipelines
  end
end

describe CardControllerTest do
  subject = CardControllerTest.new

  it "renders card index template" do
    Card.clear
    response = subject.get "/cards"

    response.status_code.should eq(200)
    response.body.should contain("Cards")
  end

  it "renders card show template" do
    Card.clear
    model = create_card
    location = "/cards/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Card")
  end

  it "renders card new template" do
    Card.clear
    location = "/cards/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Card")
  end

  it "renders card edit template" do
    Card.clear
    model = create_card
    location = "/cards/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Card")
  end

  it "creates a card" do
    Card.clear
    response = subject.post "/cards", body: card_params

    response.headers["Location"].should eq "/cards"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a card" do
    Card.clear
    model = create_card
    response = subject.patch "/cards/#{model.id}", body: card_params

    response.headers["Location"].should eq "/cards"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a card" do
    Card.clear
    model = create_card
    response = subject.delete "/cards/#{model.id}"

    response.headers["Location"].should eq "/cards"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
