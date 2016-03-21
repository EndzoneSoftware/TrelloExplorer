var authenticationSuccess = function () { console.log("Successful authentication"); };
var authenticationFailure = function () { console.log("Failed authentication"); };

Trello.authorize({
	name: "Trello Explorer",
	scope: {
		read: true
	},
	expiration: "never",
	success: authenticationSuccess,
	error: authenticationFailure
});