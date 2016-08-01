package Moblo::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub unwelcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'UnWelcome to the Mojolicious real-time web framework!');
}

1;
