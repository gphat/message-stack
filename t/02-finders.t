#!/usr/bin/perl
use strict;
use Test::More;

use Message::Stack;
use Message::Stack::Message;

my $stack = Message::Stack->new;

$stack->add({
    id => 'messageone',
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

my $clownstack = $stack->search( sub { $_[0]->subject eq 'clown' } );
cmp_ok($clownstack->count, '==', 1, 'search');

ok($stack->has_for_id('messageone'), 'has_for_id');
my $ids = $stack->for_id('messageone');
cmp_ok($ids->count, '==', 1, 'for_id: 1');
cmp_ok($ids->has_for_id('info'), '==', 0, 'has_for_id on retval');

ok($stack->has_for_level('info'), 'has_for_level');
my $errors = $stack->for_level('error');
cmp_ok($errors->count, '==', 1, 'for_level: 1');
cmp_ok($errors->has_for_level('info'), '==', 0, 'has_for_level on retval');

ok($stack->has_for_scope('bar'), 'has_for_scope');
my $bazes = $stack->for_scope('baz');
cmp_ok($bazes->count, '==', 1, 'for_scope: 1');
cmp_ok($bazes->has_for_scope('bar'), '==', 0, 'has_for_scope on retval');

ok($stack->has_for_subject('ass'), 'has_for_subject');
my $asses = $stack->for_subject('ass');
cmp_ok($asses->count, '==', 1, 'for_subject: 1');
cmp_ok($asses->has_for_subject('clown'), '==', 0, 'has_for_subject on retval');

done_testing;