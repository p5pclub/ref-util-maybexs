use strict;
use warnings;
use Ref::Util::MaybeXS;
use Test::More tests => 2;

my $cb = Ref::Util::MaybeXS->can('is_arrayref');
ok( $cb->([]), 'is_arrayref with can()' );
ok( !$cb->({}), 'is_arrayref with can()' );
