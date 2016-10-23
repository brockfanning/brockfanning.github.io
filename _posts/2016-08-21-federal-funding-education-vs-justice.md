---
title: U.S. Federal Budget for Prisons vs Schools
tags: [datavis]
---
<style>
.line {
  fill: none;
  stroke-width: 1.5px;
}
.education {
  stroke: steelblue;
  color: steelblue;
}
.justice {
  stroke: orange;
  color: orange;
}
</style>

In an effort to get my feet wet with [d3](https://d3js.org), [R](https://www.r-project.org), and data science in general, here is a basic data visualization. The idea here is to compare federal budgets over time, for prisons vs. schools. It's actually more general than that. The lines below are:

* <span class="education">Education, Training, Employment, and Social Services</span>
* <span class="justice">Administration of Justice</span>

In future posts I will delve into interactive visualizations and also try and narrow the data down.

<div id="datavis"></div>

### Source code

* [R code](https://github.com/brockfanning/brockfanning.github.io/blob/master/r/federal-outlays-by-function-and-subfunction.r)
* [d3 code](https://github.com/brockfanning/brockfanning.github.io/blob/master/_posts/2016-08-21-federal-funding-education-vs-justice.md)

### Source of data

Table 3.2 from this [OMB](https://www.whitehouse.gov/omb/budget/Historicals) page.

<script src="http://d3js.org/d3.v4.min.js"></script>
<script>
var margin = {top: 20, right: 20, bottom: 30, left: 70},
    width = 740 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var parseTime = d3.timeParse("%Y");

var x = d3.scaleTime().range([0, width]);
var y = d3.scaleLinear().range([height, 0]);

var education = d3.line()
    .x(function(d) { return x(d.year); })
    .y(function(d) { return y(d.education); });

var justice = d3.line()
    .x(function(d) { return x(d.year); })
    .y(function(d) { return y(d.justice); });

var svg = d3.select("#datavis").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.json("/data/federal-outlays-educations-vs-justice.json", function(error, data) {

    if (error) throw error;

    data.forEach(function(d) {
        d.year = parseTime(d.year);
    });

    x.domain(d3.extent(data, function(d) { return d.year; }));
    y.domain([0, d3.max(data, function(d) { return d.education; })]);

    svg.append("path")
        .data([data])
        .attr("class", "line education")
        .attr("d", education);
    svg.append("path")
        .data([data])
        .attr("class", "line justice")
        .attr("d", justice);
    svg.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x));
    svg.append("g")
        .call(d3.axisLeft(y));
    svg.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 0 - margin.left)
        .attr("x", 0 - (height / 2))
        .attr("dy", "1em")
        .style("text-anchor", "middle")
        .text("Millions of dollars");
});
</script>