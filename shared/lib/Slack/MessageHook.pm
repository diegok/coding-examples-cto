package Slack::MessageHook;
use Moo;
use Mojo::UserAgent;

has url     => is => 'ro',   required => 1;
has name    => is => 'ro',   default => sub{'CTO'};
has channel => is => 'lazy', default => sub{'#bots'};
has ua      => is => 'lazy', default => sub { Mojo::UserAgent->new };

sub send {
    my ( $self, $message ) = @_;
    $message = { text => $message } unless ref $message;
    $message->{username} ||= $self->name;
    $message->{channel}  ||= $self->channel;
    $self->ua->post_p( $self->url => json => $message );
}

1;
