
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  var params = request.params
  var lat1 = params.lat1
  var lat2 = params.lat2
  var lng1 = params.lng1
  var lng2 = params.lng2
  
  var airportsQuery = new Parse.Query('AirportsICAO');

  airportsQuery.equalTo('country', params.country);

  airportsQuery.find().then(function(AirPorts){
  	response.success(AirPorts);
  }, function(error){
  	response.error(error);
  })
});
