class CardController < ApplicationController
  def index
    cards = Card.all
    render("index.ecr")
  end

  def show
    if card = Card.find params["id"]
      render("show.ecr")
    else
      flash["warning"] = "Card with ID #{params["id"]} Not Found"
      redirect_to "/cards"
    end
  end

  def new
    card = Card.new
    render("new.ecr")
  end

  def create
    card = Card.new(card_params.validate!)

    if card.valid? && card.save
      flash["success"] = "Created Card successfully."
      redirect_to "/cards"
    else
      flash["danger"] = "Could not create Card!"
      render("new.ecr")
    end
  end

  def edit
    if card = Card.find params["id"]
      render("edit.ecr")
    else
      flash["warning"] = "Card with ID #{params["id"]} Not Found"
      redirect_to "/cards"
    end
  end

  def update
    if card = Card.find(params["id"])
      card.set_attributes(card_params.validate!)
      if card.valid? && card.save
        flash["success"] = "Updated Card successfully."
        redirect_to "/cards"
      else
        flash["danger"] = "Could not update Card!"
        render("edit.ecr")
      end
    else
      flash["warning"] = "Card with ID #{params["id"]} Not Found"
      redirect_to "/cards"
    end
  end

  def destroy
    if card = Card.find params["id"]
      card.destroy
    else
      flash["warning"] = "Card with ID #{params["id"]} Not Found"
    end
    redirect_to "/cards"
  end

  def card_params
    params.validation do
      required(:title) { |f| !f.nil? }
      required(:body) { |f| !f.nil? }
    end
  end
end
