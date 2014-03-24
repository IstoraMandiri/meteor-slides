@Slides = new Meteor.Collection 'slides'
@Decks = new Meteor.Collection 'decks'

if Meteor.isServer 

  if Decks.find().count() is 0 # populate some data

    newSlide = Slides.insert
      text: 'Hello, this is a slide'
      _deckId: 'main'
      order: 0
    
    Decks.insert
      _id: 'main'
      title: 'My first slideshow'
      currentSlide: newSlide


if Meteor.isClient

  currentDeck = -> Decks.findOne _id:'main'
  currentSlide = -> Slides.findOne currentDeck()?.currentSlide
  lastSlide = -> Slides.findOne({},{sort:{order:-1}})
  makeSlideLive = (_id) -> 
    Decks.update {_id:currentDeck()._id},
      $set: {currentSlide:_id}

  moveToSlide = (direction) ->
    newSlideOrder = currentSlide().order + direction
    newSlide = Slides.findOne({_deckId: currentDeck()._id, order:newSlideOrder})?._id
    if newSlide
      makeSlideLive newSlide

  Template.slide.text = -> currentSlide()?.text

  Template.slide_list.helpers
    slides : -> Slides.find {_deckId: currentDeck()?._id}, {sort:{order:1}}
    isCurrent : -> @_id is currentSlide()?._id
    isEditing: -> Session.equals 'editingSlide', @_id

  Template.slide_list.events
    'click .push' : -> makeSlideLive @_id
    'mouseover .slide' : -> Session.set 'editingSlide', @_id
    'mouseout .slide' : -> Session.set 'editingSlide', null

    'keyup input': (event) -> 
      event.stopPropagation()
      Slides.update {_id:@_id},
        $set: {text: event.target.value}

    'click .new' : -> 
      slideIndex = lastSlide().order + 1
      Slides.insert
        _deckId: currentDeck()?._id
        text: "New slide #{slideIndex}"
        order: slideIndex

  
  Router.configure({layoutTemplate:'layout'}).map ->
    
    @route 'main',
      path: '/'
      template: 'slide'
    
    @route 'dashboard',
      path: '/dashboard'
      template: 'dashboard'
      after: ->
        $('body').on 'keyup', (e) ->
          if e.keyCode is 39 # forward
            moveToSlide 1
          else if e.keyCode is 37 # back
            moveToSlide -1
