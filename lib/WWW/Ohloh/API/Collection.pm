package WWW::Ohloh::API::Collection;

use Moose::Role;

use Carp;

use overload '<>' => \&next;

with 'WWW::Ohloh::API::Role::Fetchable' => {
    -excludes => 'fetch'
};

has entry_class => (
    is => 'rw',
    isa => 'Str',
    lazy => 1,
    default => sub { die "'entry_class must be defaulted\n" },
);

has cached_entries => (
    traits => [ 'Array' ],
    isa => 'ArrayRef',
    is => 'ro',
    default => sub { [] },
    handles => {
        add_entries => 'push',
        cache_empty => 'is_empty',
        cache_size => 'count',
        next_from_cache => 'shift',
    },
);

after next_from_cache => sub { $_[0]->inc_entry_cursor };

has page_cursor => (
    is => 'rw',
    traits  => [ 'Counter' ],
    isa     => 'Int',
    default => 1,
    handles => {
        inc_page => 'inc',
    },
);

has entry_cursor => (
    is => 'rw',
    traits  => [ 'Counter' ],
    isa     => 'Int',
    default => 0,
    handles => {
        inc_entry_cursor => 'inc',
    },
);

has nbr_entries => (
    is => 'rw',
    isa => 'Int',
    predicate => 'has_nbr_entries',
    lazy => 1,
    default => sub {
        $_[0]->fetch->nbr_entries;
    },
);

sub fetch {
    my ( $self, @args ) = @_;
    
    # no more to fetch
    return if $self->has_nbr_entries and $self->entry_cursor >= $self->nbr_entries;

    $self->clear_request_url;

    my $xml = $self->agent->_query_server($self->request_url);

    $self->nbr_entries( $xml->findvalue( '/response/items_available' ) );

    my @entries = $xml->findnodes( '//result/child::*' );
    my $first = $xml->findvalue( '/response/first_item_position' );

    while ( @entries and $first < $self->entry_cursor ) {
        shift @entries;
        $first++;
    }

    $self->add_entries( $xml->findnodes( '//result/child::*' ));

    $self->inc_page;

    return $self;
};

sub all {
    my $self = shift;

    my @entries;

    while ( my $e = $self->next ) {
        push @entries, $e;
    }

    return @entries;
}

sub next {
    my $self = shift;

    $DB::single = 1;

    return if $self->entry_cursor >= $self->nbr_entries;

    if ( $self->cache_empty ) {
        $self->fetch;
    }

    my $raw = $self->next_from_cache or return;

    return $self->entry_class->new(
        agent   => $self->agent,
        xml_src => $raw,
    );
}

around _build_request_url => sub {
    my( $inner, $self ) = @_;
    
    my $uri = $inner->($self);

    my $params = $uri->query_form_hash;

    $params->{page} = $self->page_cursor;

    $uri->query_form_hash( $params );
    
    return $uri;
};

1;

__END__

has total_nbr_entries => (
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
