From the biclustering plots of each Congress, it can be seen that the grand majority of senators
votes according to their party. In other words, there is very high intra-party cohesion and very
low inter-party cohesion. The plots provide an intuitive visualization of the bipartisanism that
currently dominates US politics.

In terms of the given data, a polarization measure could be the difference between political
ideologies. Republicans should almost always vote based on conservative values and Democrats
should almost always vote based on liberal values. A simple way to determine whether or not there
is polarization is to calculate the 95% confidence intervals for each party; if there is no
overlap, then I would say that there is polarization. The difference between the intervals could
be used as the measure of polarization.

Another possible approach is to use kurtosis. If there is low kurtosis, then there is high
polarization, as most values would be on the two extremes rather than the middle. Notably, the 
107th Congress has a relatively high kurtosis value of 9.087. This was likely due to the fact that
the 9/11 attacks occurred before the meeting and there was nearly unanimous support for anti-terrorism
legislation such as the PATRIOT Act. On the other hand, the 111th Congress had high polarization,
likely because Obama was just inaugurated and there was a Democratic majority in both the House and
the Senate, so Republicans felt that they were forced to vote adversely to the president's agenda.

A simple measure and visualization of polarization would be the kurtosis subtracted from 10. 
Initially, I used the multiplicative inverse of kurtosis, but I felt that subtracting from 10
provided results that were easier to visualize.

The roll call data codes are as follows (voteview.com):
0 - Not a member
1 - Yea
2 - Paired Yea
3 - Announced Yea
4 - Announced Nay
5 - Paired Nay
6 - Nay
7/8 - Present
9 - Not voting

Only 1 through 6 seemed meaningful, so the rest of the codes were mapped to NaN for the kurtosis 
calculation. However, this produced different results than the original data and I could not make
intuitive sense of it based on the historical legislation, so both polarization timelines are given.
