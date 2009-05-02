package WWW::Ohloh::API::Attr::XMLExtract;

use Moose::Role;

has 'xml_src' => ( isa => 'Str', );

has xpath => ( isa => 'Str', );

has '+lazy' => ( default => 1 );

before '_process_options' => sub {
    my ( $class, $name, $options ) = @_;

    die "attribute '$name' in class '$class' must be lazy-evaluated\n"
      if defined $options->{lazy} and not $options->{lazy};

    my $src   = $options->{xml_src} ||= 'xml_src';
    my $xpath = $options->{xpath}   ||= $name;

    $options->{default} = sub {
        return $_[0]->$src->findvalue($xpath);
    };

};

1;

