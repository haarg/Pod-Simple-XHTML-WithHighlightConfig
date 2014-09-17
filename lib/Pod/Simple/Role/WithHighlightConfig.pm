package Pod::Simple::Role::WithHighlightConfig;
use Moo::Role;

sub BUILD {}

after BUILD => sub {
  $_[0]->accept_targets('highlighter');
};

has highlight_config => (is => 'rwp', init_arg => undef);
has _highlight_scratch => (is => 'rw', clearer => 1, init_arg => undef);

around _handle_element_start => sub {
  my $orig = shift;
  my $self = shift;
  my ($element, $item) = @_;
  if ($element eq 'for' && $item->{target_matching} eq 'highlighter') {
    $self->_highlight_scratch({
      config_text => '',
    });
  }
  else {
    $self->$orig(@_);
  }
};

around _handle_text => sub {
  my $orig = shift;
  my $self = shift;
  my ($text) = @_;
  if (my $scratch = $self->_highlight_scratch) {
    $scratch->{config_text} .= $text;
  }
  else {
    $self->$orig(@_);
  }
};

around _handle_element_end => sub {
  my $orig = shift;
  my $self = shift;
  my ($element, $item) = @_;

  if ($element eq 'for' and my $scratch = $self->_highlight_scratch) {
    $self->_clear_highlight_scratch;
    my $text = $scratch->{config_text};
    my @config = split /(\S+)\s*=/, $text;
    shift @config;
    s/^\s+//, s/\s+$// for @config;
    $self->_set_highlight_config({ @config });
  }
  else {
    $self->$orig(@_);
  }
};

1;
__END__

