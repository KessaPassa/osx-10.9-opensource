use Config::Std;
use Test::More 'no_plan';

my $output_file = 'test.cfg';

my %data = (
    # Default section...
    '' => {
        'def1'     => 'def val 1',
        'def 2'    => 'def val 2',
        'def 3 ml' => "def val 3\nacross several\n   lines",
    },

    # Named section...
    'Named' => {
        'hi there' => q{What's your name???},
        'list'     => [qw(a list of values), 'all different'],
    },

    # Complex named section...
    'Complex named!!!' => {
        123456789 => 'zero',
        '%^$%$#%' => 'curses',
    },
);

ok eval{ write_config %data => $output_file }    => 'Write succeeded';

ok open(my $fh, '<', $output_file)               => 'File created';

ok my $config = do{ local $/; <$fh> }            => 'File read';

ok my $orig_config = do{ local $/; <DATA> }      => 'DATA loaded';

is $orig_config, $config                         => 'Content correct';


__DATA__

def 2: def val 2

def 3 ml: def val 3
        : across several
        :    lines

def1: def val 1

[Complex named!!!]

%^$%$#%: curses

123456789: zero

[Named]

hi there: What's your name???

list: a
list: list
list: of
list: values
list: all different

