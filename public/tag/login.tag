<login>

  <div class="container">
    <!--User sign in or sign up -->
    <div class="login-wrapper">

      <div class="login">
        <form class="login-form" onsubmit={ login }>
          <h3> Log In </h3>
          <input type="email" onkeyup={ editEmail } placeholder="Email@">
          <input type="password" onkeyup={ editPassword } placeholder="Password">
          <button disabled={ !email || !password }>Log In</button>
        </form>
      </div>
    </div>

    <div class="or">
      <p>OR</p>
    </div>

    <div class="login-wrapper">

      <div class="signup">
        <form class="signup-form" onsubmit={ signup }>
          <h3> Sign Up </h3>
          <input onkeyup={ editUsername } placeholder="Username">
          <input type="email" onkeyup={ editEmail } placeholder="Email@">
          <input type="password" onkeyup={ editPassword } placeholder="Password">
          <button disabled={ !username || !email || !password } class="signup-form-button">Sign Up</button>
        </form>
      </div>

    </div>
  </div>


  <script>
    login(e) {
      if (this.email && this.password) {
        loginUser(this.email, this.password)
      }
      e.preventDefault()
    }

    signup(e) {
      if (this.username && this.email && this.password) {
        if (validateUsername(this.username)) {
          signupUser(this.username, this.email, this.password)
        }
      }
      e.preventDefault()
    }

    // Track changes to email input
    editEmail(e) {
      this.email = e.target.value
    }

    // Track changes to password input
    editPassword(e) {
      this.password = e.target.value
    }

    // Track changes to username input
    editUsername(e) {
      this.username = e.target.value
    }

    function signupUser(username, email, password) {

      firebase.auth().createUserWithEmailAndPassword(email, password).catch(function (error) {
        // Handle errors here.
        // TODO: add error messages to login
        var errorCode = error.code;
        var errorMessage = error.message;
        console.log(errorCode, errorMessage)
      }).then(function (user) {
        // Create user and mark as disconnected for now
        firebase.database().ref('users/' + user.uid).set({
          username: username,
          connected: false
        });
      });
    }

    function loginUser(email, password) {

      firebase.auth().signInWithEmailAndPassword(email, password).catch(function (error) {
        // Handle errors here.
        // TODO: add error messages to login
        var errorCode = error.code;
        var errorMessage = error.message;
        console.log(errorCode, errorMessage)
      });
    }

    // Validate usernames are alphanumeric
    function validateUsername(username) {
      var alphanum = /^[0-9a-zA-Z]+$/
      return alphanum.test(username)
    }
  </script>

</login>