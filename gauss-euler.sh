#!/bin/sh
#
# $Id: gauss-euler.sh,v 1.1 2014/03/19 11:14:18 urs Exp $

tmp=`mktemp`
trap "rm $tmp" 0

# Print all lines from input whose value in a specified column is unique
uniqcol() {
    awk "
	BEGIN{ count = -1 }
	{
		if (last != \$$1) {
			if (count == 0)
				print lastline
			count = 0
		} else {
			count++
		}
		lastline = \$0
		last = \$$1
	}
	END{ if (count == 0) print lastline }"
}

# Create all possible tuples (n, m, s, p) with factorization of p
for n in `seq 2 99`; do
    for m in `seq $n 99`; do
	s=$(($n + $m))
	p=$(($n * $m))
	printf "%2d %2d %3d %4d: %s\n" $n $m $s $p "`factor $p | sed s/.*://`"
    done
done > 1-all

# Find all the tuples for which the product is unique
sort -k4n 1-all | uniqcol 4 > 2-unique-prod

# Find all sums for which at least one product is not unique
seq 4 198 | sort > $tmp
awk '{print $3}' 2-unique-prod | sort | comm -23 $tmp - > 3-possible-sums

# Find all the tuples with a possible sum
awk '{print $3,NR}' 1-all | sort | join -v1 - 3-possible-sums |
	awk '{print $2"d"}' > $tmp
sed -f $tmp 1-all > 4-tuples-with-possible-sum

# Find those tuples whose product is unique among the tuples with a
# possible sum
sort -k4n 4-tuples-with-possible-sum | uniqcol 4 > 5-unique-prod

# Find among the unique products those whose sum is unique
sort -k3n 5-unique-prod | uniqcol 3
