use 5.010001;
use strict;
use warnings;

package TAP::Formatter::EARL::Session;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

use Moo;
use Data::Dumper;

use Types::Standard qw(ConsumerOf);
use Attean;
use Attean::RDF;
use Types::Namespace qw( NamespaceMap );
use Types::Attean qw(to_AtteanIRI);


has model => (is => 'ro',
				  required => 1,
				  isa => ConsumerOf['Attean::API::MutableModel']);

has ns => (
			  is => "ro",
			  isa => NamespaceMap,
			  required => 1,
			 );

has graph_name => (
						 is => "rw",
						 isa => AtteanIRI,
						 required => 1
						);


sub result {
  my ($self, $result) = @_;
  my $giri = $self->graph_name;
  my $ns = $self->ns;
  if ($result->isa('TAP::Parser::Result::Test')) {
	 my $tiri = iri('http://example.org/test/result/timestamp#test_num_' . $result->number);
	 $self->model->add_quad(quad($tiri, to_AtteanIRI($ns->rdf->type), to_AtteanIRI($ns->earl->TestResult), $giri));
	 my $outcome = $result->is_ok ? $ns->earl->passed : $ns->earl->failed;
	 if ($result->directive) {
		# Then, the test is either TODO or SKIP, they lack description
		$outcome = $ns->earl->untested;
		$self->model->add_quad(quad($tiri, to_AtteanIRI($ns->earl->info), langliteral($result->directive . ': ' . $result->explanation, 'en'), $giri));
	 } else {
		$self->model->add_quad(quad($tiri, to_AtteanIRI($ns->dct->title), langliteral($result->description, 'en'), $giri));
	 }
	 $self->model->add_quad(quad($tiri, to_AtteanIRI($ns->earl->outcome), to_AtteanIRI($outcome), $giri));
  }
}

sub close_test {
  return; # No-op for now
}
1;

__END__

=pod

=encoding utf-8

=head1 NAME

TAP::Formatter::EARL::Session - Session implementation for TAP Formatter to EARL

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

Please report any bugs to
L<https://github.com/kjetilk/p5-tap-formatter-earl/issues>.

=head1 SEE ALSO

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2019 by Inrupt Inc.

This is free software, licensed under:

  The MIT (X11) License


=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

