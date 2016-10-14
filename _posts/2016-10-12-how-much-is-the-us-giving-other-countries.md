---
title: How Much Money is the US giving other countries?
tags: [datavis]
---
Here is a statistic I have been curious about: how much money does the US give to other countries? This was a good chance to stretch my R and D3 chops.

<div id="datavis"></div>

Dev steps:

* Install rJava and Tabulizer: https://github.com/ropenscilabs/tabulizer
* Run R code
* Install ogr2ogr and topojson
* Get geo data and create map json
* Write d3 code

<script src="https://d3js.org/d3.v4.min.js"></script>
<script src="https://d3js.org/topojson.v1.min.js"></script>
<script src="https://d3js.org/d3-queue.v3.min.js"></script>
<script>
var width = 740,
    height = 475;

var svg = d3.select("#datavis").append("svg")
    .attr("width", width)
    .attr("height", height);

d3.queue()
    .defer(d3.json, "/data/geo/world-countries.json")
    .defer(d3.json, "/data/us-foreign-aid.json")
    .await(analyze);

function analyze(error, world, aid) {

    // For now just look at one year.
    var year = "2013 actual";

    // Make a more efficient list of totals.
    var totals = {};
    for (var country in aid[year]) {
        totals[aid[year][country].code] = aid[year][country].total;
    }

    var subunits = topojson.feature(world, world.objects.subunits);
    var projection = d3.geoMercator()
        .scale(170)
        .translate([width / 2, height / 2]);
    var path = d3.geoPath().projection(projection);
    var maxVal = d3.max(aid[year], function(d) { return d.total; });
    var minVal = 0;
    var scale = d3.scaleLinear()
        .range(["#EEEEEE", "#000000"])
        .domain([minVal, maxVal]);

    svg.selectAll(".subunit")
        .data(subunits.features)
        .enter().append("path")
        .style("stroke", "#000000")
        .style("fill", function(d) { if (totals[d.id]) return scale(totals[d.id]); return "#FFFFFF"; })
        .attr("d", path);

    var mapCodes = {};
    for (var country in subunits.features) {

        var id = subunits.features[country].id;
        var name = subunits.features[country].properties.name;
        mapCodes[id] = name;
    }
    for (var countryCode in totals) {
        if (typeof mapCodes[countryCode] === 'undefined') {
            console.log(countryCode);
        }
    }

}
</script>