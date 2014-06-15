myApp = angular.module("ithings", [
  "ngRoute"
  "firebase"
])


myApp.value "fbURL", "https://interesting-things.firebaseio.com/things/"


myApp.factory "Things", ($firebase, fbURL) ->
  $firebase new Firebase(fbURL)


myApp.config ($routeProvider) ->
  $routeProvider.when("/",
    controller: "ListCtrl"
    templateUrl: "list.html"
  ).when("/edit/:thingId",
    controller: "EditCtrl"
    templateUrl: "detail.html"
  ).when("/new",
    controller: "CreateCtrl"
    templateUrl: "detail.html"
  ).otherwise redirectTo: "/"




myApp.controller "ListCtrl", ($scope, Things) ->
  $scope.things = Things


myApp.controller "CreateCtrl", ($scope, $location, $timeout, Things) ->
  $scope.save = ->
    Things.$add $scope.thing, ->
      $timeout ->
        $location.path "/"


myApp.controller "EditCtrl", ($scope, $location, $routeParams, $firebase, fbURL) ->
  thingUrl = fbURL + $routeParams.thingId
  $scope.thing = $firebase(new Firebase(thingUrl))
  $scope.destroy = ->
    $scope.thing.$remove()
    $location.path "/"

  $scope.save = ->
    $scope.thing.$save()
    $location.path "/"
