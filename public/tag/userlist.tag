<userlist>
  <ul class="names">
    <li class="name" each={ user, i in users }>
      { user }
    </li>
  </ul>

  <script>
    var tag = this

    tag.users = []
    firebase.database().ref("users").orderByChild("connected").equalTo(true).on("value", function (snapshot) {
      tag.users = [];
      snapshot.forEach(function (childSnapshot) {
        var user = childSnapshot.val()
        if (childSnapshot.key === firebase.auth().currentUser.uid) {
          user.username = "*" + user.username
        }
        tag.users.push(user.username);
      });
      tag.update()
    });
  </script>
</userlist>