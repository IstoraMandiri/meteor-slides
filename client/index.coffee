

currentDeck = -> Decks.findOne {_id:'main'}
currentSlide = -> Slides.findOne currentDeck()?.currentSlide
lastSlide = -> Slides.findOne({},{sort:{order:-1}})

makeSlideLive = (_id) -> 
  Decks.update {_id:currentDeck()._id},
    $set: {currentSlide:_id}

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
  isEditing: -> Session.equals 'editingSlide', @_id

Template.slide_list.events
  'click .push' : -> makeSlideLive @_id
  'mouseover .slide' : -> Session.set 'editingSlide', @_id
  'mouseout .slide' : -> Session.set 'editingSlide', null
  