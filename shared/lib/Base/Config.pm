package Base::Config;
use Moo;
use File::Slurp;
use Mojo::JSON qw/ decode_json /;

has file => is => 'lazy', default => sub { 'shared/config.json' };

has root => is => 'lazy', default => sub {
    my $file = shift->file;
    die "Missing config file: $file" unless -f $file;
    decode_json( scalar read_file( $file ) );
};

=method extra

This class implement a little hack over AUTOLOAD (method missing)
so first level keys on the config hash can be accessed as methods
on this config object.

=cut
sub AUTOLOAD {
    my $self = shift;
    my ($subname) = $Base::Config::AUTOLOAD =~ /::([^:]+)$/;

    return exists $self->root->{$subname}
        ? $self->root->{$subname}
        : undef;
}

1;
