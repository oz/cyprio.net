---
title: "Rebenchmarking Go, Crystal, and Ruby"
---

Don't you ever tire of benchmarks? Most of those are inaccurate, hardly
reproducible, and often misleading. With that out of the way, I present a
benchmark of some _very fine_ programs to compare the speeds of [Go][go],
[Crystal][crystal], and [Ruby][ruby]. ;)

I like Ruby a lot, have used Go for some years, and I consider that Crystal is
an interesting middle ground: both nice _and_ fast, although not as mature as
the two others, yet.

I recently stumbled upon [Guirec Corbel's benchmark][previously] (in French) of
the three technologies, written in 2015. I though it would be interesting to
check the results a year apart, but we could hardly compare our benchmarks
since we're not using the same hardware, and so I just re-benched everything.

I did some guess work to select the same versions that he _probably_ benched in
September 2015, and proceeded to rerun these on my ancient (2011) laptop. This
way, we should get a more accurate idea of the evolution of our tools.

I ran these benchmarks from Archlinux, on this CPU: Intel(R) Core(TM) i7-2620M
CPU @ 2.70GHz. The programs are sourced from @kostya's [benchmark
repository][benchsrc]: not all implementations are optimized, but they tend to
show how a language performs when the code is more or less identical.
Furthermore, I had to dig up old Crystal code to run on 2015's version (0.7).

For each program, I simply measured the running time, taking the best of 5...
If you want averages and variance, [pull-requests are warmly
welcomed][send-pr].

# Results 2015

We compare the execution time of 4 little benchmarks using:

 - Go 1.5 (released 08/2015)
 - Crystal 0.7.7 (released 09/2015)
 - Ruby 2.2.4 (released 12/2015)

Benchmark           Go         Crystal      Ruby
-----------------   --------   ----------   ---------
Fibonnacci (1M)     4.16s      3.20s        11.34s
Brainfuck           6.01s      6.76s        3:03s
Havlak              40.87s     18.69s       N/A
Matmul (1500)       5.01s      4.89s        6:01s

Now fear my mad GNUPlot skills:

![Execution time (2015): comparing Go, Crystal, and Ruby](https://static.cypr.io/wtf/bench-2015.png)

OK, let's just remove Ruby here:

![Execution time (2015): comparing Go & Crystal](https://static.cypr.io/wtf/bench-2015-no-ruby.png)

# Results 2016

We compare again the execution time of the same 4 benchmarks using:

 - Go 1.7.4
 - Crystal 0.20.1
 - Ruby 2.4.0-preview3

Benchmark           Go         Crystal      Ruby
-----------------   --------   ----------   ---------
Fibonnacci (1M)     4.94s      3.18s        11.23s
Brainfuck           5.18s      3.29s        2:19s
Havlak              36.61s     14.32s       N/A
Matmul (1500)       4.13s      4.04s        5:46s

![Execution time (2016): comparing Go, Crystal, and Ruby](https://static.cypr.io/wtf/bench-2016.png)

Again, without Ruby:

![Execution time (2016): comparing Go & Crystal](https://static.cypr.io/wtf/bench-2016-no-ruby.png)

# Comparing speed gains

These numbers do not look like much, but let's put them on a graph to
compare the gains. On this graph, 100% means 2015 speed, lower means
worse performance, so higher is better:

![Speed gains from 2015 to 2016 in Go, Crystal, and Ruby benchmarks](https://static.cypr.io/wtf/evolution.png)

It's easier to grasp how these platforms are all[^1] getting better.

These benchmarks only solicitate _one_ CPU core, so they are a small
part of a bigger story where concurrency and parallelism play a major
role. Having said that, I'd really like it if Ruby's MRI would get
faster _faster_

I wonder if more Rubyists will switch to Crystal: clearly, the
platform is just getting warmed up, and will probably get speedier
with time. It is already on par with Go's speed (even slightly
faster), has not even reached a 1.0 version, and yet continually
improves.

Courting Ruby developers with speed only may not work: after all, it
took _Rails_ to make the language successful.

To me, Go has gained the safer-choice award after several releases. It
is a stable platform, continually improving, thanks to the backing of
Google. Also... channels are <3. :)

The question we Rubyists should ask ourselves is maybe which tool
should we use when our next project hits a performance limit, safe of
fun?


[^1]: I don't really understand how Go has gotten worse at calculating
    Fibonnacci. I hope you don't do that too much in your day to day
    business. :p

[go]: https://golang.org
[crystal]: https://crystal-lang.org/
[ruby]: https://www.ruby-lang.org/en/
[previously]: http://gcorbel.github.io/blog/blog/2015/09/07/benchmark-go-vs-crystal-vs-ruby/
[send-pr]: https://github.com/oz/cyprio.net
[benchsrc]: https://github.com/kostya/benchmarks
