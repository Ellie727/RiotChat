<app>

  <!--If user is not logged in, then sign up/sign is displayed-->
  <login if={ !isLoggedIn }></login>

  <!--If user is logged in chatroom, then it is displayed-->
  <chatroom if={ isLoggedIn } config={ opts.config }></chatroom>

  <script>
    // Save scope context for use in other functions
    var tag = this

    tag.isLoggedIn = false
    tag.userId = null

    // Listen for authentication event to mark user as connected
    firebase.auth().onAuthStateChanged(function (user) {
      if (user) {
        tag.isLoggedIn = true
        tag.userId = user.uid
        firebase.database().ref('users/' + tag.userId).update({
          connected: true
        });
      } else {
        tag.isLoggedIn = false
      }
      tag.update()
    });

    //When user closes window their "connected" flag goes to false
    window.addEventListener('beforeunload', function () {
      if (tag.isLoggedIn) {
        firebase.database().ref('users/' + tag.userId).update({
          connected: false
        });
      }
    });
  </script>

</app>