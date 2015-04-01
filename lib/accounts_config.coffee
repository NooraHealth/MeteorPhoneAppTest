AccountsTemplates.configure {
    confirmPassword: true,
    enablePasswordChange: true,
    forbidClientAccountCreation: false,
    overrideLoginErrors: false,
    sendVerificationEmail: true,
    lowercaseUsername: false,

    # Appearance
    showAddRemoveServices: false,
    showForgotPasswordLink: false,
    showLabels: true,
    showPlaceholders: true,
    defaultLayout: 'entry',

    # Client-side Validation
    continuousValidation: false,
    negativeFeedback: false,
    negativeValidation: true,
    positiveValidation: true,
    positiveFeedback: true,
    showValidating: true,

    # Privacy Policy and Terms of Use
    privacyUrl: 'privacy',
    termsUrl: 'terms-of-use',

    # Redirects
    homeRoutePath: '/home',
    redirectTimeout: 4000,

    # Hooks
    #onLogoutHook: myLogoutFunc,
    #onSubmitHook: () ->
      #if !error
        #Router.go "/"

    # Texts
    texts: {
      button: {
          signUp: "Register Now!"
      },
      socialSignUp: "Register",
      socialIcons: {
          "meteor-developer": "fa fa-rocket"
      },
      title: {
          forgotPwd: "Recover Your Password"
      },
    }
}

AccountsTemplates.configureRoute 'ensureSignedIn', {
  template: 'entry',
  layoutTemplate: 'layout'
}

Router.plugin "ensureSignedIn"
