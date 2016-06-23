use strict;
use warnings;
use Test::More tests => 1;
use Ref::Util::MaybeXS 'is_arrayref';

sub arrayref { [] }
ok( is_arrayref( arrayref() ), 'Got arrayref from expression' );
