// Class User

function User() {} // Constructor
 
/**
 * Get the no of users
 * @return {number} The size.
 */
User.prototype.getUsers = function() {
  // No implementation.
};

// Class Admin

function Admin(){}

/**
 * Get access permission
 * @return {Boolean}
 */
Admin.prototype.getAccess = function(){}

/**
 * Get Roles
 * @return {collection} the roles
 */
Admin.prototype.getRoles = function(){}

//Extending
inherits(Admin, User);

// inherits
/**
 * Helper function that implements (pseudo)Classical inheritance inheritance.
 * @param {Function/Class} childClass
 * @param {Function/Class} parentClass
 */
function inherits(childClass, parentClass) {
  /** @constructor */
  var tempClass = function() {
  };
  tempClass.prototype = parentClass.prototype;
  childClass.prototype = new tempClass();
  childClass.prototype.constructor = childClass;
}