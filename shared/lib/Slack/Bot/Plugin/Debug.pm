package Slack::Bot::Plugin::Debug;
use Moo;
use v5.26;

has bot => is => 'ro', required => 1;

sub message {
    my ( $self, $message ) = @_;
    say "Channel: ", $message->channel_name;
    say "From: ", $message->user_name;
    say $message->text;
}

sub tick {
    say 'tick';
}

1;
