//Messages Model  
module.exports = {
	config: {
	    user: 'root',
	    password: '111111',
	    database: 'sampleAppMessages',
	    host: 'mongodb://localhost'
	  },

    attributes  : {
    	indexkey: 	'INTEGER', 
        timestamp: 	'DATE',
        userId: 	'STRING',
        message: 	'STRING',
    }
};