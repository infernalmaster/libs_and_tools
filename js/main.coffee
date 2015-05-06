myApp = angular.module("ithings", [
  "ngRoute"
  "firebase"
])


myApp.value "fbURL", "https://interesting-things.firebaseio.com"


myApp.factory "Auth", (fbURL, $firebaseAuth) ->
  $firebaseAuth new Firebase(fbURL)

myApp.factory "Things", ($firebase, fbURL) ->
  $firebase new Firebase("#{fbURL}/things/")




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




myApp.controller "ListCtrl", ($scope, Things, Auth) ->
  $scope.things = Things.$asArray()

  $scope.myComparator = (actual, expected) ->
    if actual == undefined
        # No substring matching against `undefined`
        return false
    if actual == null or expected == null
        # No substring matching against `null`; only match against `null`
        return actual == expected

    actual = ('' + actual).toLowerCase()
    expected = ('' + expected).toLowerCase()

    expected.split(' ').every (one) -> actual.indexOf(one) != -1


  $scope.auth = Auth
  $scope.auth.$onAuth ->
    $scope.$evalAsync ->
      $scope.user = $scope.auth.$getAuth()


myApp.controller "CreateCtrl", ($scope, $location, Things) ->
  $scope.save = ->
    Things.$asArray().$add( $scope.thing ).then( -> $location.path "/" )


myApp.controller "EditCtrl", ($scope, $location, $routeParams, Things) ->
  things = Things.$asArray()
  things.$loaded().then ->
    $scope.thing = things.$getRecord($routeParams.thingId)

  $scope.destroy = ->
    things.$remove($scope.thing).then( -> $location.path "/" )

  $scope.save = ->
    things.$save($scope.thing).then( -> $location.path "/" )
