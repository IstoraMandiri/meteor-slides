

currentDeck = -> Decks.findOne {_id:'main'}
currentSlide = -> Slides.findOne currentDeck()?.currentSlide
lastSlide = -> Slides.findOne({},{sort:{order:-1}})

Template.slide.text = -> currentSlide()?.text


Template.controls.events
  'click .new' : -> 
    slideIndex = lastSlide().order + 1
    Slides.insert
      _deckId: currentDeck()?._id
      text: "New slide #{slideIndex}"
      order: slideIndex


Template.slide_list.helpers
  slides : -> Slides.find {_deckId: currentDeck()?._id}
  isCurrent : -> @_id is currentSlide()?._id

  