# Constructor

###*
# Get the no of users
# @return {number} The size.
###

# Class User

User = ->

# Class Admin

Admin = ->

# inherits

###*
# Helper function that implements (pseudo)Classical inheritance inheritance.
# @param {Function/Class} childClass
# @param {Function/Class} parentClass
###

inherits = (childClass, parentClass) ->

  ###* @constructor ###

  tempClass = ->

  tempClass.prototype = parentClass.prototype
  childClass.prototype = new tempClass
  childClass::constructor = childClass
  return

User::getUsers = ->
  # No implementation.
  return

###*
# Get access permission
# @return {Boolean}
###

Admin::getAccess = ->

###*
# Get Roles
# @return {collection} the roles
###

Admin::getRoles = ->

#Extending
inherits Admin, User
