#!perl
use strict;
use Test::More;

use Message::Stack;
use Message::Stack::Message;

my $stack = Message::Stack->new;

$stack->add({
    msgid => 'messageone',
    text => 'Foo',
    level => 'error',
    scope => 'bar',
    subject => 'ass'
});

$stack->add({
    text => 'Foo',
    level => 'info',
    scope => 'baz',
    subject => 'clown'
});

cmp_ok($stack->count, '==', 2, 'Two in the stack before');
$stack->reset_for_scope('bar');
cmp_ok($stack->count, '==', 1, 'One in the stack after');

done_testing;
