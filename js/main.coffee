angular.module("ithings", [
  "ngRoute"
  "firebase"
]).value("fbURL", "https://interesting-things.firebaseio.com/things/"
).factory("Things", ($firebase, fbURL) ->
  $firebase new Firebase(fbURL)


).config(($routeProvider) ->
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


).controller("ListCtrl", ($scope, Things) ->
  $scope.things = Things


).controller("CreateCtrl", ($scope, $location, $timeout, Things) ->
  $scope.save = ->
    Things.$add $scope.thing, ->
      $timeout ->
        $location.path "/"

).controller "EditCtrl", ($scope, $location, $routeParams, $firebase, fbURL) ->
  thingUrl = fbURL + $routeParams.thingId
  $scope.thing = $firebase(new Firebase(thingUrl))
  $scope.destroy = ->
    $scope.thing.$remove()
    $location.path "/"

  $scope.save = ->
    $scope.thing.$save()
    $location.path "/"
