use inc::Module::Install;

name     'Message-Stack';
all_from 'lib/Message/Stack.pm';
author   'Cory G Watson <gphat@cpan.org>';
license  'perl';

build_requires 'Test::More' => '0.92';

requires 'Moose' => '0.90';
requires 'MooseX::Types' => '0.21';
requires 'MooseX::Storage' => '0.21';
requires 'JSON::Any' => '1.22';

WriteAll;

