package Task::SlackMessage;
use Resque::WorkerClass;
use Base::Config;
use Slack::MessageHook;

has message => is => 'ro', isa => 'Str', required => 1;

has hook_url => is => 'ro', lazy => 1, default => sub{
    Base::Config->new->slack->{hook_url}
};

has slack    => is => 'ro', lazy => 1, default => sub{
    Slack::MessageHook->new( url => shift->hook_url )
};

sub run {
    my $self = shift;

    $self->slack->send( $self->message )->wait;
}

1;
