#!/usr/bin/perl -w

use strict;
use Test::More tests => 442;

use Number::WithError::LaTeX qw/:all/;

my @tests = (
	[3.14159, 0.12],
	[3],
	[3.123, 0],
	[123, undef, 0.123],
	[0, 0, 0, 0],
	[0],
	[3, 1],
	[3, 10.3],
	[3, 10.12312, [123, 0.000001]],
);

foreach my $constructor (0..3) {
	print "# constructor $constructor.\n";
	foreach my $t (@tests) {
		my $n;
		if ($constructor == 0) {
			$n = witherror(@$t);
		}
		elsif ($constructor == 1) {
			$n = Number::WithError::LaTeX->new(@$t);
		}
		elsif ($constructor == 2) {
			$n = witherror_big(@$t);
		}
		else {
			$n = Number::WithError::LaTeX->new_big(@$t);
		}

		isa_ok($n, 'Number::WithError::LaTeX');
		isa_ok($n, 'Number::WithError');

		print "# Object: $n\n";

		my $str = $n->latex();
		
		ok(defined($str) && $str ne '', 'latex() returns string');
		
		ok($str =~ /\\cdot/, 'string contains cdot');
		
		my $str2 = $n->latex(enclose => '', radix => '.');
		
		ok(defined($str2) && $str2 ne '', 'latex() returns string (2)');
		is($str, $str2, 'defaults work');

		my $str3 = $n->latex(enclose => '$', radix => '.');
		ok(defined($str3) && $str3 ne '', 'latex() returns string (3)');
		my $str4 = $n->latex_math();
		ok(defined($str4) && $str4 ne '', 'latex_math() returns string (4)');
		is($str3, $str4, 'latex_math() returns correct result');

		my $str5 = $n->latex(enclose => ["\\begin{equation}\n", "\n\\end{equation}"], radix => '.');
		ok(defined($str5) && $str5 ne '', 'latex() returns string (5)');
		my $str6 = $n->latex_equation();
		ok(defined($str6) && $str6 ne '', 'latex_math() returns string (6)');
		is($str5, $str6, 'latex_equation() returns correct result');
	}
}


# This is bad. FIXME
my $foo = Number::WithError::LaTeX->new(1);
for (1..10) {
	ok(defined($foo->encode($_)), 'encode() return value defined');
}

