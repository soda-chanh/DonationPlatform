
// MAIL

Parse.Cloud.define("sendMail", function(request, response) {
	var Mandrill = require('mandrill');
	Mandrill.initialize('WAB8OOuBVMc49yyn8lIEmQ');

	Mandrill.sendEmail({
		message: {
			text: request.params.text,
			subject: request.params.subject,
			from_email: request.params.fromEmail,
			from_name: request.params.fromName,
			to: [
			{
				email: request.params.toEmail,
				name: request.params.toName
			}
			]
		},
		async: true
	},{
		success: function(httpResponse) {
			console.log(httpResponse);
			response.success("Email sent!");
		},
		error: function(httpResponse) {
			console.error(httpResponse);
			response.error("Uh oh, something went wrong");
		}
	});
});


// STRIPE
// THIS USES A TEST TOKEN!!
// live api key: sk_live_UyGw7VeGM2KqVQiA3YfnV1IV

Parse.Cloud.define("createStripePayment", function(request, response) {
	var Stripe = require('stripe');
	Stripe.initialize('sk_test_YcnLvVwpzSa8zvn2piWU8Sbz');

	console.log("request: " + request);
	console.log("params: " + request.params);
	console.log("amount: " + request.params.amount);
	console.log("card: " + request.params.card);
	Stripe.Charges.create({
		amount: request.params.amount,
		currency: "usd",
		card: request.params.card
	},{
		success: function(httpResponse) {
			console.log(httpResponse);
			response.success("Email sent!");
		},
		error: function(httpResponse) {
			console.error(httpResponse.message);
			response.error(httpResponse.message);
		}
	});
});

// var api_key = "YOUR_MAILCHIMP_API_KEY";

// // use https and last verison
// var options = {secure: true, version: "1.3"};

// // Set the path to the mailchimp module
// // If you cloned the mailchimp lib somewhere else, it's time to set this
// // value properly
// var module_path = "cloud/libs/mailchimp/";

// var MailChimpAPI = require(module_path+"MailChimpAPI.js");
// var myChimp = new MailChimpAPI(api_key, options, module_path); 
// myChimp.ping({}, function(error, data){
//     // data is a string or JSON parsed object
//     if(error){
//         // Oops… there was a problem...
//     }else{
//         // Do something with the data
//     }
//     // Handle what to do with the ping
// });
// //or
// // Parse callback style
// myChimp.ping({}, {
//     success: function(data){
//         // data is a string or JSON parsed object
//         // Howdy! The ping worked!
//     },
//     error: function(error){
//         // Something went wrong...
//     }
// });
