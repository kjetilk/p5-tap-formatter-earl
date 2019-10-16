
=encoding utf-8

=head1 PURPOSE

Simple unit test for TAP::Formatter::EARL::Session

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is Copyright (c) 2019 by Inrupt Inc.

This is free software, licensed under:

  The MIT (X11) License


=cut

use strict;
use warnings;
use Test::Modern;
use Test::More;
use Attean;
use Attean::RDF;

use_ok("TAP::Formatter::EARL::Session");

my $s = object_ok(
						sub { TAP::Formatter::EARL::Session->new(
																			  model => Attean->temporary_model,
																			  software_uri => iri('http://example.org/script'),
																			  ns => URI::NamespaceMap->new( [ 'rdf', 'dc', 'earl', 'doap' ] ),
																			  graph_name => iri('http://example.org/graph'),
																			  result_prefix => URI::Namespace->new('http://example.org/result#'),
																			  assertion_prefix => URI::Namespace->new('http://example.org/assertion#'),
																			 ) }, '$s',
						can => [qw(model ns graph_name software_uri result_prefix assertion_prefix close_test result)]);


is($s->model->size, 0, 'Model is empty');

done_testing;
