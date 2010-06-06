package WWW::Ohloh::API::Collection;

use Moose;

use Carp;

our $VERSION = '1.0_1';

use overload '<>' => \&next;

has cache => (
    isa => 'ArrayRef',
    is => 'ro',
    default => sub { [] },
);

has total_entries => (
    isa => 'Int',
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;

        $self->_gather_more;

        return $self->total_entries;
    },
);

has page => (
    isa => 'Int',
    is => 'ro',
);

has max => ( isa => 'Int', is => 'ro', );

has element => ( is => 'ro' );

has sort_order => ( is => 'ro' );

has read_so_far => ( is => 'ro' );

has all_read => ( is => 'ro', default => 0 );

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub next {
    my $self = shift;
    my $nbr_requested = shift || 1;

    while ( @{ $cache_of[$$self] } < $nbr_requested
        and not $all_read[$$self] ) {
        $self->_gather_more;
    }

    my @bunch = splice @{ $cache_of[$$self] }, 0, $nbr_requested;

    if (@bunch) {
        return wantarray ? @bunch : $bunch[0];
    }

    # we've nothing else to return

    $page_of[$$self]  = 0;
    $all_read[$$self] = 0;

    return;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

before 'shift_cache' => sub {
    my $self = shift;

    $self->_gather_more unless $self->nbr_in_cache;
};

after 'shift_cache' => sub {
    my $self = shift;

    return unless $self->all_read;

    $self->clear_state;
};


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


sub _gather_more {
    my $self = shift;

    my ( $url, $xml ) = $ohloh_of[$$self]->_query_server(
        $self->query_path,
        {   ( query => $query_of[$$self] ) x !!$query_of[$$self],
            ( sort => $sort_order_of[$$self] ) x !!$sort_order_of[$$self],
            page => ++$page_of[$$self] } );

    my $class = $self->element;
    my @new_batch =
      map { $class->new( ohloh => $ohloh_of[$$self], xml_src => $_, ) }
      $xml->findnodes( $self->element_name );

    if ( defined( $self->max ) )
        and $self->get_read_so_far + @new_batch > $self->max ) {
        @new_batch =
          @new_batch[ 0 .. $self->max - $self->get_read_so_far - 1 ];
        $all_read[$$self] = 1;
    }

    if ( my $read = @new_batch ) {
        $self->add_to_read_so_far( $read );
    }
    else {
        $self->set_all_read(1);
    }

    # get total elements + where we are  (but don't trust it)

    $self->set_total_entries(
        $xml->findvalue('/response/items_available/text()') );

    my $first_item = $xml->findvalue('/response/first_item_position/text()');

    $self->push_cache( @new_batch );

    $self->set_all_read(1) if $self->total_entries == $self->read_so_far;

    return;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub clear_state {
    my $self = shift;

    $self->clear_page;
    $self->clear_cache;
    $self->clear_all_read;
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub all {
    my $self = shift;

    my @bunch;

    while( my $x = $self->next ) {
        push @bunch, $x;
    }

    $self->clear_state;

    return @bunch;
}

1;
