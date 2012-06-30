package WWW::Ohloh::API::Role::Attr::XMLExtract;

use Moose::Role;

has 'xml_src' => ( isa => 'Str', is => 'ro' );

has xpath => ( isa => 'Str', is => 'ro' );

has 'lazy' => ( is => 'ro', default => 1 );

before '_process_options' => sub {
    my ( $class, $name, $options ) = @_;

    die "attribute '$name' in class '$class' must be lazy-evaluated\n"
      if defined $options->{lazy} and not $options->{lazy};

    my $src   = $options->{xml_src} ||= 'xml_src';
    my $xpath = $options->{xpath}   ||= $name;

    $options->{predicate} = 'has_' . $name;

    $options->{default} = sub {
        # return unless $_[0]->$predicate;

        return $_[0]->$src->findvalue($xpath);
    };

};

1;

