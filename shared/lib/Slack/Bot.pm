package Slack::Bot;
use Moo;
use v5.26;

use Mojo::IOLoop;
use Mojo::SlackRTM;
use Slack::Bot::Message;

require UNIVERSAL::require;

has token      => is => 'ro', required => 1;
has connection => is => 'lazy', default => sub { Mojo::SlackRTM->new( token => shift->token ) };

has ticker => is => 'lazy', default => sub {
    my $self = shift;
    Mojo::IOLoop->recurring( 1 => sub{ $self->tick } );
};

has plugins  => is => 'ro', default => sub{[qw/ Debug /]};
has _plugins => is => 'rw', default => sub{[]};

sub run {
    my $self = shift;
    $self->_init_plugins;
    $self->_init_events;
    while (1) {
        $self->connection->log->debug('Connecting...');
        $self->connection->connect;
        $self->connection->log->debug('Connected');
        Mojo::IOLoop->start;
        $self->connection->log->debug('Disconnected');
    }
}

sub _init_plugins {
    my $self = shift;
    for my $plugin_name ( $self->plugins->@* ) {
        $self->register_plugin( $plugin_name );
    }
}

sub register_plugin {
    my ( $self, $name ) = @_;
    die 'Need plugin name to load!' unless $name;

    $name = "Slack::Bot::Plugin::$name" unless $name =~ /::/;
    if ( $name->use ) {
        my $plugin = eval { $name->new( bot => $self ) };
        if ($@) {
            warn "Plugin '$name' not loaded: $@";
            return;
        }
        push @{$self->_plugins}, $plugin;
        return $plugin;
    }
    else {
        warn "Plugin '$name' not loaded: $@";
    }
}

sub _init_events {
    my $self = shift;
    my $slack = $self->connection;

    $slack->on( message => sub {
        my ($slack, $event) = @_;
        $self->dispatch( message => Slack::Bot::Message->new(
            slack => $slack,
            event => $event
        ))
    });

    $self->ticker;
}

sub tick { shift->connection->log->debug('tick') }

sub dispatch {
    my ( $self, $event ) = ( shift, shift );
    for my $plugin ( $self->_plugins->@* ) {
        $plugin->$event(@_) if $plugin->can($event);
    }
}

1;
