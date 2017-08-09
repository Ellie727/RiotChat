<chatroom>

  <div class="chat-wrapper">
    <div class="chat-area">
      <ul class="chat-log" id="chat-log">
        <li class="chat-message" each={ messages }>
          <span if={ isClient } class="client username">{ username }</span>
          <span if={ !isClient } class="username">{ username }</span>
            ({timestamp}): { message }
        </li>
      </ul>
      <div class="chat-entry">
        <form onsubmit={ enterMessage }>
          <input class="chat-input" ref="input" onkeyup={ edit }>
          <button class="chat-button" disabled={ !text }>Enter</button>
        </form>
      </div>
    </div>

    <!--Currently logged on user list is displayed-->
    <div class="users-area">
      <userlist class="users-list"></userlist>
      <button class="logout-button" onclick={ logout }>Log Out</button>
    </div>
  </div>


  <script>
    var tag = this

    logout(e) {
      var userid = firebase.auth().currentUser.uid
      firebase.auth().signOut().then(function () {
        // Make sure logged out users are marked as disconnected
        firebase.database().ref('users/' + userid).update({
          connected: false
        });
      });
    }

    tag.text = null
    // Track message input box text changes
    edit(e) {
      tag.text = e.target.value
    }

    // Attempt to save message to db after message submission
    enterMessage(e) {
      if (tag.text) {
        firebase.database().ref('messages').push().set({
          message: tag.text,
          userid: firebase.auth().currentUser.uid,
          username: tag.user,
          timestamp: firebase.database.ServerValue.TIMESTAMP
        });
        // Reset input box after submission
        tag.text = tag.refs.input.value = ""
      }
      e.preventDefault()
    }

    tag.user = null
    // On load, get username based on userid from database
    firebase.database().ref("users/" + firebase.auth().currentUser.uid).once("value", function (snapshot) {
      tag.user = snapshot.val().username
      tag.update()
    });

    tag.messages = []
    // On load, get latest 5 messages and listen for more added
    firebase.database().ref("messages").limitToLast(5).on("child_added", function (snapshot) {
      var message = snapshot.val()

      message.timestamp = convertTimeToLocaleString(message.timestamp)
      if (message.userid === firebase.auth().currentUser.uid) {
        message.isClient = true;
      }
      tag.messages.push(message)

      // Flag to autoscroll chatbox
      tag.flagAutoscroll = true;
      tag.update()
    });

    tag.flagAutoscroll = false;
    // On updates, check if the chatbox needs to be autoscrolled to the bottom
    tag.on('updated', function() {
      if (tag.flagAutoscroll) {
        //Grabs chatlog div
        var chatlog = document.getElementById('chat-log');

        //Allows for chat window to automatically scroll when new messages appear
        chatlog.scrollTop = chatlog.scrollHeight - chatlog.scrollTop;

        // Reset flag
        tag.flagAutoscroll = false;
      }
    });

    //Converts timestamp into readable time for chatlog
    function convertTimeToLocaleString(time){
      var date = new Date(time);
      date = date.toLocaleTimeString();

      // Simple way to handle single digit hours
      if (date.length === 10) {
        return date.slice(0,4) + date.slice(7);
      }
      return date.slice(0,5) + date.slice(8);
    }
  </script>

</chatroom>