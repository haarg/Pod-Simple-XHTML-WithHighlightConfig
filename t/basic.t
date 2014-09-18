use strict;
use warnings;
use Test::More;

use Pod::Simple::XHTML::WithHighlightConfig;

my $input = 't/data/module.pod';
my $p = Pod::Simple::XHTML::WithHighlightConfig->new;
$p->output_string(\my $html);
$p->parse_file($input);

like $html,
  qr{<b>text</b>},
  'html sections preserved';

like $html,
  qr{<pre><code class="language-perl">  my \$var = foo\(\);</code></pre>},
  'language config set in class';
like $html,
  qr{<pre><code>  Just a verbatim section</code></pre>},
  'empty language config resets settings';
like $html,
  qr{<pre data-start="5" data-line="1,4-10,20" class="line-numbers"><code class="language-javascript">  Another verbatim section</code></pre>},
  'start line, line numbers, highlight lines set properly';
like $html,
  qr{<pre><code class="language-javascript">  Another verbatim section 2</code></pre>},
  'bare language';

like $html,
  qr{<dt>Around line 29:</dt>\s*<dd>\s*<p>Invalid empty line_numbers setting\.</p>},
  'errors for invalid line_numbers';

like $html,
  qr{<dt>Around line 33:</dt>\s*<dd>\s*<p>Invalid setting &quot;welp&quot;\.</p>},
  'errors for invalid settings';

done_testing;
