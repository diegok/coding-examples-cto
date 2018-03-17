package Slack::Bot::Message;
use Moo;

has slack => is => 'ro', required => 1;
has event => is => 'ro', required => 1;

sub text {
    shift->event->{text};
}

sub user_name {
    my $self = shift;
    $self->slack->find_user_name($self->event->{user});
}

sub channel_name {
    my $self = shift;
    $self->slack->find_channel_name($self->event->{channel});
}

sub reply {
    my $self = shift;
    $self->slack->send_message(
        $self->event->{channel_id} => shift
    );
}

1;
