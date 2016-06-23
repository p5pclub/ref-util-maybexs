use strict;
use warnings;
use Test::More tests => 7;

BEGIN {
    use_ok('Ref::Util::MaybeXS');
    Ref::Util::MaybeXS->import('is_arrayref');
}

can_ok( Ref::Util::MaybeXS::, 'is_arrayref' );
Ref::Util::MaybeXS::is_arrayref(\1);

ok( !is_arrayref(\1), 'Correctly identify scalarref' );
ok( !is_arrayref({}), 'Correctly identify hashref' );
ok( !is_arrayref(sub {}), 'Correctly identify coderef' );
ok( !is_arrayref(qr//), 'Correctly identify regexpref' );
ok( is_arrayref([]), 'Correctly identify arrayref' );
