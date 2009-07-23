use inc::Module::Install;

name     'Message-Stack';
all_from 'lib/Message/Stack.pm';
author   'Cory G Watson <gphat@cpan.org>';
license  'perl';

build_requires 'Test::More';

requires 'Moose' => '0.87';
requires 'MooseX::AttributeHelpers' => '0.20';

WriteAll;

