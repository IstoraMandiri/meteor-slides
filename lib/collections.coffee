
@Slides = new Meteor.Collection 'slides'
@Decks = new Meteor.Collection 'decks'

if Meteor.isServer

  if Decks.find().count() is 0
    console.log 'inserting new deck'
    
    newSlide = Slides.insert
      text: 'Hello, this is a slide'
      _deckId: 'main'
      order: 0
    
    Decks.insert
      _id: 'main'
      title: 'My first slideshow'
      currentSlide: newSlide