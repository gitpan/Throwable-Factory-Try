#!perl -T
use 5.10.0;
use strict;
use warnings FATAL => 'all';
use Test::More;

use lib 'lib';
use Throwable::Factory
    FooBarException => ['-notimplemented'],
;
use Throwable::Factory::Try;

plan tests => 3;

my $ok;

###### TYPE test
$ok = 0;
try {
    FooBarException->throw('test')
}
catch [
    'FooBarException' => sub { $ok = 1 },
];

ok($ok, "TYPE catch");

######  Regexp test
$ok = 0;
try {
    FooBarException->throw('test')
}
catch [
    qr/^Foo/ => sub { $ok = 1 },
],
finally {
    $ok = 1
};

ok($ok, "Regexp catch");

###### taxonomy test
$ok = 0;
try {
    FooBarException->throw('test')
}
catch [
    '-notimplemented' => sub { $ok = 1 },
];

ok($ok, "Taxonomy catch");
