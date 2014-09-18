package Pod::Simple::XHTML::WithHighlightConfig;
use Moo;

our $VERSION = '0.000001';
$VERSION = eval $VERSION;

extends 'Pod::Simple::XHTML';
with 'Pod::Simple::Role::WithHighlightConfig';

around start_highlight => sub {
  my ($orig, $self, $item, $config) = @_;
  $self->$orig($item, $config);
  $config ||= {};
  my $tag = '<pre';
  my @classes;
  if ($config->{line_numbers}) {
    push @classes, 'line-numbers';
    if ($config->{start_line}) {
      $tag .= ' data-start="' . $self->encode_entities($config->{start_line}) . '"';
    }
  }
  if ($config->{highlight}) {
    $tag .= ' data-line="' . $self->encode_entities($config->{highlight}) . '"';
  }
  if (@classes) {
    $tag .= ' class="' . join (' ', @classes) . '"';
  }
  $tag .= '><code';
  if ($config->{language}) {
    my $lang = lc $config->{language};
    $lang =~ s/\+/p/g;
    $lang =~ s/\W//g;
    $tag .= ' class="language-' . $lang . '"';
  }
  $tag .= '>';
  $self->{scratch} = $tag;
};

1;
__END__

=head1 NAME

Pod::Simple::XHTML::WithHighlightConfig - Allow configuring syntax highlighting hints in Pod

=head1 SYNOPSIS

  =head1 SYNOPSIS

  =for highlighter language=javascript

    var date = new Date();

  =for highlighter language=perl line_numbers=1 start_line=5

    my @array = map { $_ + 1 } (5..10);

=head1 DESCRIPTION

This module allows adding syntax highlighter hints to a Pod document to be
rendered as XHTML.  Normally, verbatim blocks will be represented inside
C<< <pre><code>...</code></pre> >> tags.  The information will be represented
as class names and data attributes on those tags.

Configuration values effect all verbatim blocks until the next highlighter
configuration directive.

=head1 CONFIGURATION

The supported configuration attributes are as follows:

=over 4

=item language

This is the language to highlight the verbatim blocks with.  It will be
represented as a C<language-$language> class on the C<< <code> >> tag.

=item line_numbers

A true or false value indicating if line numbers should be included.  If true,
it will be represented as a C<line-numbers> class on the C<< <pre> >> block.

=item start_line

A number for what to start numbering lines as rather than starting at 1.  Only
valid when the C<line_numbers> option is enabled.  It will be represented as a
C<data-start> attribute on the C<< <pre> >> block.

=item highlight

A comma separated list of lines or line ranges to highlight, such as C<5>,
C<4-10>, or C<1,4-6,10-14>.  It will be represented as a C<data-line> attribute
on the C<< <pre> >> block.

=back

=head1 SEE ALSO

=over 4

=item * L<TOBYINK::Pod::HTML> - Another module using the same configuration
format

=item * L<http://www.w3.org/TR/html5/text-level-semantics.html#the-code-element|HTML5 code element> - Semantics for highlighting encouraged by the HTML4 spec

=item * L<http://prismjs.com/|Prism> - A javascript syntax highlighter
supporting the classes and attributes used by this module

=back

=head1 AUTHOR

haarg - Graham Knop (cpan:HAARG) <haarg@haarg.org>

=head2 CONTRIBUTORS

None so far.

=head1 COPYRIGHT

Copyright (c) 2014 the Pod::Simple::XHTML::WithHighlightConfig L</AUTHOR> and
L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
