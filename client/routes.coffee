Router.configure
  layoutTemplate: 'layout'

Router.map ->
  
  @route 'main',
    path: '/'
    template: 'slide'

  @route 'dashboard',
    path: '/dashboard'
    template: 'dashboard'    