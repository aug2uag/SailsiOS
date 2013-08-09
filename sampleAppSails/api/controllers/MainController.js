var MainController = {
 
  	seedTableView: function(req, res) {
  	//query db, return results
  	//if results not empty, send as JSON
  	res.send(storedMessages);

	res.writeHead(200,{"Content-Type":"text/html"});
    	res.end();
    }

};
module.exports = MainController;  