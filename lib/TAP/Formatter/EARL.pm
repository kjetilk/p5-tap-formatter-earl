use 5.010001;
use strict;
use warnings;

package TAP::Formatter::EARL;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

use Moo;
use Data::Dumper;

use TAP::Formatter::EARL::Session;
use Types::Standard qw(ConsumerOf);
use Types::Namespace qw( NamespaceMap );
use Attean;
use Attean::RDF;
use Types::Attean qw(AtteanIRI to_AtteanIRI);

extends qw(
    TAP::Formatter::Console
);

has model => (is => 'rw',
				  isa => ConsumerOf['Attean::API::MutableModel'],
				  builder => '_build_model');

sub _build_model {
  my $self = shift;
  return Attean->temporary_model;
}

has ns => (
			  is => "ro",
			  isa => NamespaceMap,
			  builder => '_build_ns'
			 );

sub _build_ns {
  my $self = shift;
  return URI::NamespaceMap->new( [ 'rdf', 'dct', 'earl', 'doap' ] );
}

has graph_name => (
						 is => "rw",
						 isa => AtteanIRI,
						 coerce => 1,
						 default => sub {'http://example.org/graph'});



sub open_test {
  my $self = shift;
  my $giri = $self->graph_name;
  my $ns = $self->ns;
  my $siri = iri('http://example.org/test/assertor#this');
  $self->model->add_quad(quad($siri, to_AtteanIRI($ns->rdf->type), to_AtteanIRI($ns->earl->Software), $giri));
  $self->model->add_quad(quad($siri, to_AtteanIRI($ns->doap->name), literal(__PACKAGE__), $giri));
  $self->model->add_quad(quad($siri, to_AtteanIRI($ns->doap->release), blank('rev'), $giri));
  $self->model->add_quad(quad(blank('rev'), to_AtteanIRI($ns->doap->revision), literal($VERSION), $giri));
  # TODO: Add rdfs:seeAlso the CPAN doap


  return TAP::Formatter::EARL::Session->new(model => $self->model,
														  ns => $self->ns,
														  graph_name => $giri
														 )
}

sub summary {
  my $self = shift;
  my $s = Attean->get_serializer('Turtle')->new(namespaces => $self->ns);
  open(my $fh, ">-:encoding(UTF-8)");
  $s->serialize_iter_to_io( $fh, $self->model->get_quads);
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

TAP::Formatter::EARL - Formatting TAP output using the Evaluation and Report Language

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

Please report any bugs to
L<https://github.com/kjetilk/p5-tap-formatter-earl/issues>.

=head1 SEE ALSO

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2019 by Inrupt Inc

This is free software, licensed under:

  The MIT (X11) License


=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

