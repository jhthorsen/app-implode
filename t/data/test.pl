#!/usr/bin/env perl
use Mojo::Util;
print Mojo::Util::md5_sum(shift || 0), "\n";
