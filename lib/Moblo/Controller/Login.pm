  package Moblo::Controller::Login;
  use Mojo::Base 'Mojolicious::Controller';
  
  # This action will render a template
  sub checkLogin {
    my $self = shift;
    return 1;
  }
  
  
  sub checkSession{
    my $self = shift;
    my $sessionkey = $self->cookie('session');
    my $session_status = $self->login->checkSessionKey($sessionkey);
    my $json_data = "";
    if (!$session_status) {
      #code
      $self->render(json => {status => "notAuthenticated",message=>"Please login to use the service"});  
    }else{
      $self->login->markSessionActivity($sessionkey);
      $self->render(json => {status => "Authenticated",message=>"Please wait while we redirect you to dashboard."});
    }  
  }
  
  sub loginAttempt{
    
    my $self = shift;
    my $sessionkey = $self->cookie('session');
    #my $session_status = true;
    if(!$self->login->checkSessionKey($sessionkey)){
      
      my $validation = $self->_validation;
      return $self->render(json => {status => "notAuthenticated",message=>"Either username or password is blank"})
        if $validation->has_error;
      my $username = $self->param('username');
      my $password = $self->param('password');
      my $user_id = $self->login->validateLogin($username,$password);
      
      if (!$user_id){
        return $self->render(json => {status => "notAuthenticated",message=>"Authentication Failure. Either User name or password is wrong"});   
      }
      my $sessionKey = $self->login->markLoginActivity($user_id);
      if (!$sessionKey) {
          return $self->render(json => {status => "notAuthenticated",message=>"Unexpected Error. Please contact Administrator."});
      }
      $self->cookie(session => $sessionKey);
      return $self->render(json => {status => "Authenticated",message=>"Please wait while we redirect you to dashboard."});
    }else{
      $self->login->markSessionActivity($sessionkey);
      $self->render(json => {status => "Authenticated",message=>"Updated active session, redirecting to Dashboard."});
    }
    
  }
  
  sub logout{
    
    my $self = shift;
    my $sessionkey = $self->cookie('session');
    $self->cookie('session' => '', {expires => 1});
    $self->login->markLogoutActivity($sessionkey);
    return $self->render(json => {status => "notAuthenticated",message=>"Please login to use the service."});
  }
  
  sub getDashBoardDetails{
    
    my $self = shift;
    my $sessionkey = $self->getSessionKey();
    my $session_status = $self->login->checkSessionKey($sessionkey);
    if (!$session_status) {
      $self->render(json => {status => "notAuthenticated",message=>"Please login to use the service"});  
    }else{
      my $insertion_details = $self->login->getSessionDBInsertionDetails($sessionkey);
      $self->render(json => {status => 'Authenticated',details => [$insertion_details]});
        
    }
    
  }
  
  sub _validation {
    my $self = shift;
    my $validation = $self->validation;
    $validation->required('username');
    $validation->required('password');
    return $validation;
  }
  
  sub getSessionKey{
    my $self = shift;
    return  $self->cookie('session');
  }
  1;