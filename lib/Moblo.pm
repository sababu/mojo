package Moblo;
use Mojo::Base 'Mojolicious';
use Moblo::Model::Login;
use Mojo::SQLite;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  my $sql = Mojo::SQLite->new('sqlite:obruman.db');
  $self->helper(sqlite => sub { state $sql = Mojo::SQLite->new('sqlite:obruman.db')});
  $self->helper(login => sub { state $login = Moblo::Model::Login->new(sqlite => shift->sqlite) });
  
  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('login#index');
  $r->get('/checkSessionStatus')->to('login#checkSession');
  $r->get('/getDashBoardDetails')->to('login#getDashBoardDetails');
  $r->post('/attemptLogin')->to('login#loginAttempt');
  $r->post('/logout')->to('login#logout');
}

1;
