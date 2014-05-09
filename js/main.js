(function() {
  angular.module("ithings", ["ngRoute", "firebase"]).value("fbURL", "https://interesting-things.firebaseio.com/things/").factory("Things", function($firebase, fbURL) {
    return $firebase(new Firebase(fbURL));
  }).config(function($routeProvider) {
    return $routeProvider.when("/", {
      controller: "ListCtrl",
      templateUrl: "list.html"
    }).when("/edit/:thingId", {
      controller: "EditCtrl",
      templateUrl: "detail.html"
    }).when("/new", {
      controller: "CreateCtrl",
      templateUrl: "detail.html"
    }).otherwise({
      redirectTo: "/"
    });
  }).controller("ListCtrl", function($scope, Things) {
    return $scope.things = Things;
  }).controller("CreateCtrl", function($scope, $location, $timeout, Things) {
    return $scope.save = function() {
      return Things.$add($scope.thing, function() {
        return $timeout(function() {
          return $location.path("/");
        });
      });
    };
  }).controller("EditCtrl", function($scope, $location, $routeParams, $firebase, fbURL) {
    var thingUrl;
    thingUrl = fbURL + $routeParams.thingId;
    $scope.thing = $firebase(new Firebase(thingUrl));
    $scope.destroy = function() {
      $scope.thing.$remove();
      return $location.path("/");
    };
    return $scope.save = function() {
      $scope.thing.$save();
      return $location.path("/");
    };
  });

}).call(this);
