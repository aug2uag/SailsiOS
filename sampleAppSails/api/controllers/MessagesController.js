/**
 * MessagesController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */

module.exports = {

  /* e.g.
  sayHello: function (req, res) {
    res.send('hello world!');
  }
  */

  seedTableView: function(req, res) {
  	//query db
  	res.send(storedMessages);
  }
  

};
