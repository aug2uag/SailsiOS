//Users Model 
module.exports = {

 adapter: 'mongo',
 schema: true,

	config: {
	    user: 'root',
	    password: '111111',
	    database: 'sampleAppUsers',
	    host: 'mongodb://localhost'
	  },

		
	attributes  : {
	     phonename: 'STRING',
	     deviceType:'STRING',
	     deviceId: 	'STRING' //displays the device unique identifier     
	}
};

/*

// api/models/User.js
module.exports = {

  adapter: 'mongo',

  config: {
    user: 'root',
    password: 'thePassword',
    database: 'testdb',
    host: '127.0.0.1'
  },

  attributes: {
    name: 'string',
    email: 'string',
    phoneNumber: {
      type: 'string',
      defaultsTo: '555-555-5555'
    }
  }

};

*/