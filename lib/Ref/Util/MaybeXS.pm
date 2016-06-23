package Ref::Util::MaybeXS;

# ABSTRACT: Load XS version of Ref::Util if available, otherwise Pure-Perl

use strict;
use warnings;
use Carp         ();
use Scalar::Util ();
use Exporter 5.57 'import';

our %EXPORT_TAGS = ( 'all' => [qw<
    is_ref
    is_scalarref
    is_arrayref
    is_hashref
    is_coderef
    is_regexpref
    is_globref
    is_formatref
    is_ioref
    is_refref

    is_plain_ref
    is_plain_scalarref
    is_plain_arrayref
    is_plain_hashref
    is_plain_coderef
    is_plain_globref
    is_plain_formatref
    is_plain_refref

    is_blessed_ref
    is_blessed_scalarref
    is_blessed_arrayref
    is_blessed_hashref
    is_blessed_coderef
    is_blessed_globref
    is_blessed_formatref
    is_blessed_refref
>] );

our @EXPORT    = ();
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

# ----
# -- is_*
# ----

sub is_ref($) { ref $_[0] }

sub is_scalarref($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'SCALAR';
}

sub is_arrayref($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'ARRAY';
}

sub is_hashref($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'HASH';
}

sub is_coderef($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'CODE';
}

sub is_regexpref($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'REGEXP';
}

sub is_globref($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'GLOB';
}

sub is_formatref($) {
    !$^V || $^V lt v5.7.0
        and
        Carp::croak("is_formatref() isn't available on Perl 5.6.x and under");

    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'FORMAT';
}

sub is_ioref($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'IO';
}

sub is_refref($) {
    no warnings 'uninitialized';
    Scalar::Util::reftype( $_[0] ) eq 'REF';
}

# ----
# -- is_plain_*
# ----

sub is_plain_ref($) { ref $_[0] && !Scalar::Util::blessed( $_[0] ) }

sub is_plain_scalarref($) {
    no warnings 'uninitialized';
    !Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'SCALAR';
}

sub is_plain_arrayref($) {
    no warnings 'uninitialized';
    !Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'ARRAY';
}

sub is_plain_hashref($) {
    no warnings 'uninitialized';
    !Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'HASH';
}

sub is_plain_coderef($) {
    no warnings 'uninitialized';
    !Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'CODE';
}

sub is_plain_globref($) {
    no warnings 'uninitialized';
    !Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'GLOB';
}

sub is_plain_formatref($) {
    !$^V || $^V lt v5.7.0
        and
        Carp::croak("is_formatref() isn't available on Perl 5.6.x and under");

    no warnings 'uninitialized';
    !Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'FORMAT';
}

sub is_plain_refref($) {
    no warnings 'uninitialized';
    !Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'REF';
}

# ----
# -- is_blessed_*
# ----

sub is_blessed_ref($) { ref $_[0] && Scalar::Util::blessed( $_[0] ) }

sub is_blessed_scalarref($) {
    no warnings 'uninitialized';
    Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'SCALAR';
}

sub is_blessed_arrayref($) {
    no warnings 'uninitialized';
    Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'ARRAY';
}

sub is_blessed_hashref($) {
    no warnings 'uninitialized';
    Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'HASH';
}

sub is_blessed_coderef($) {
    no warnings 'uninitialized';
    Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'CODE';
}

sub is_blessed_globref($) {
    no warnings 'uninitialized';
    Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'GLOB';
}

sub is_blessed_formatref($) {
    !$^V || $^V lt v5.7.0
        and
        Carp::croak("is_formatref() isn't available on Perl 5.6.x and under");

    no warnings 'uninitialized';
    Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'FORMAT';
}

sub is_blessed_refref($) {
    no warnings 'uninitialized';
    Scalar::Util::blessed( $_[0] )
        && Scalar::Util::reftype( $_[0] ) eq 'REF';
}

BEGIN {
    # there are three scenarios:
    # 1. User specified either XS or PP:
    #    We need to try and load it and decide whether it works.
    # 2. User did not specify and we try to load and succeed.
    # 3. User did not specify and we try to laod and fail.
    our $BACKEND = $ENV{'PERL_REF_UTIL_BACKEND'};
    my ( $HAS_XS, $load_error ) = do {
        eval { require Ref::Util; 1 }
        ? ( 1, 0 )
        : ( 0, $@ );
    };

    $BACKEND ||= $HAS_XS ? 'XS' : 'PP';

    my @functions = qw<
        is_ref
        is_scalarref
        is_arrayref
        is_hashref
        is_coderef
        is_regexpref
        is_globref
        is_formatref
        is_ioref
        is_refref

        is_plain_ref
        is_plain_scalarref
        is_plain_arrayref
        is_plain_hashref
        is_plain_coderef
        is_plain_globref
        is_plain_formatref
        is_plain_refref

        is_blessed_ref
        is_blessed_scalarref
        is_blessed_arrayref
        is_blessed_hashref
        is_blessed_coderef
        is_blessed_globref
        is_blessed_formatref
        is_blessed_refref
    >;

    if ( $BACKEND eq 'XS' ) {
        $load_error and die "Cannot load Ref::Util: $@\n";
        no strict 'refs'; ## no critic
        no warnings;
        #foreach my $function (@functions) {
        #    *{"Ref::Util::MaybeXS::$function"}
        #        = *{"Ref::Util::$function"};
        #}

        *Ref::Util::MaybeXS::is_ref       = *Ref::Util::is_ref;
        *Ref::Util::MaybeXS::is_scalarref = *Ref::Util::is_scalarref;
        *Ref::Util::MaybeXS::is_arrayref  = *Ref::Util::is_arrayref;
        *Ref::Util::MaybeXS::is_hashref   = *Ref::Util::is_hashref;
        *Ref::Util::MaybeXS::is_coderef   = *Ref::Util::is_coderef;
        *Ref::Util::MaybeXS::is_regexpref = *Ref::Util::is_regexpref;
        *Ref::Util::MaybeXS::is_globref   = *Ref::Util::is_globref;
        *Ref::Util::MaybeXS::is_formatref = *Ref::Util::is_formatref;
        *Ref::Util::MaybeXS::is_ioref     = *Ref::Util::is_ioref;
        *Ref::Util::MaybeXS::is_refref    = *Ref::Util::is_refref;

        *Ref::Util::MaybeXS::is_plain_ref = *Ref::Util::is_plain_ref;
        *Ref::Util::MaybeXS::is_plain_scalarref
            = *Ref::Util::is_plain_scalarref;
        *Ref::Util::MaybeXS::is_plain_arrayref
            = *Ref::Util::is_plain_arrayref;
        *Ref::Util::MaybeXS::is_plain_hashref = *Ref::Util::is_plain_hashref;
        *Ref::Util::MaybeXS::is_plain_coderef = *Ref::Util::is_plain_coderef;
        *Ref::Util::MaybeXS::is_plain_globref = *Ref::Util::is_plain_globref;
        *Ref::Util::MaybeXS::is_plain_formatref
            = *Ref::Util::is_plain_formatref;
        *Ref::Util::MaybeXS::is_plain_refref = *Ref::Util::is_plain_refref;

        *Ref::Util::MaybeXS::is_blessed_ref = *Ref::Util::is_blessed_ref;
        *Ref::Util::MaybeXS::is_blessed_scalarref
            = *Ref::Util::is_blessed_scalarref;
        *Ref::Util::MaybeXS::is_blessed_arrayref
            = *Ref::Util::is_blessed_arrayref;
        *Ref::Util::MaybeXS::is_blessed_hashref
            = *Ref::Util::is_blessed_hashref;
        *Ref::Util::MaybeXS::is_blessed_coderef
            = *Ref::Util::is_blessed_coderef;
        *Ref::Util::MaybeXS::is_blessed_globref
            = *Ref::Util::is_blessed_globref;
        *Ref::Util::MaybeXS::is_blessed_formatref
            = *Ref::Util::is_blessed_formatref;
        *Ref::Util::MaybeXS::is_blessed_refref
            = *Ref::Util::is_blessed_refref;

    } elsif ( $BACKEND eq 'PP' ) {
        # We already defined them?
        1;
    } else {
        Carp::croak("PERL_REF_UTIL_BACKEND '$BACKEND' not supported");
    }
}

1;

__END__

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION
