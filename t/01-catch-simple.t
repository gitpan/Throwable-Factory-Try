#!perl -T
use 5.10.0;
use strict;
use warnings FATAL => 'all';
use Test::More;

use lib 'lib';
use Throwable::Factory::Try;

plan tests => 5;

my $ok;

###### "catch all" test
$ok = 0;
try {
    die
}
catch [
    '*' => sub { $ok = 1 },
];

ok($ok, "'Catch all' catch");

######  finally via catch test
$ok = 0;
try {
    die
}
catch [
    '*' => sub {}
],
finally {
    $ok = 1
};

ok($ok, "Finally via catch");

###### string test
$ok = 0;
try {
    die 'test'
}
catch [
    ':str' => sub { $ok = 1 },
];

ok($ok, "String catch");

###### class test
$ok = 0;
try {
    my $obj = bless {}, 'My::Exception::Class';
    die $obj
}
catch [
    'My::Exception::Class' => sub { $ok = 1 },
];

ok($ok, "Class catch");

###### role test
$ok = 0;
{
    package My::Role;
    our $VAR=0;
    package My::Class;
    use base 'My::Role';
    
    sub new { return bless {}, 'My::Class' };
    
    package main;
    
    try {
        my $obj = My::Class->new;
        die $obj;
    }
    catch [
        'My::Role' => sub { $ok = 1 }
    ]
}

ok($ok, "Role catch");
