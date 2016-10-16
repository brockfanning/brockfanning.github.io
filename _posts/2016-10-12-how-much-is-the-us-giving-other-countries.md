---
title: How Much Money is the US giving other countries?
tags: [datavis]
---
Here is a statistic I have been curious about: how much money does the US give to other countries? This was a good chance to stretch my R and D3 chops.

<div id="datavis"></div>

Dev steps:

* Install rJava and Tabulizer: https://github.com/ropenscilabs/tabulizer
* Run R code to generate us-foreign-aid.json file
* Install ogr2ogr and topojson
* Get geo data and create map json
    * Download and unzip geo data: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_map_units.zip
    * Run ogr2ogr on the .shp file: `ogr2ogr -f "GeoJSON" subunits.json ne_50m_admin_0_map_units.shp`
    * Run topojson on that file: `topojson -o world-countries.json --id-property iso_a3 --properties name=name -- subunits.json`
* Write d3 code

<script src="https://d3js.org/d3.v4.min.js"></script>
<script src="https://d3js.org/topojson.v1.min.js"></script>
<script src="https://d3js.org/d3-queue.v3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/numeral.js/1.5.3/numeral.min.js"></script>
<script>
var width = 740,
    height = 475;

var svg = d3.select("#datavis").append("svg")
    .attr("width", width)
    .attr("height", height);

var tooltip = d3.select("body").append("div")
    .style("position", "absolute")
    .style("padding", "0 10px")
    .style("background", "#CCC")
    .style("opacity", 0);

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
    var countries = {};
    for (var country in aid[year]) {
        countries[aid[year][country].code] = aid[year][country].country;
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
        .on("mouseover", function(d) {
            tooltip.transition()
                .style("opacity", .9);
            tooltip.html(d.properties.name + ": " + numeral(totals[d.id] * 1000).format("($ 0.00a)"))
                .style("left", (d3.event.pageX - 10) + "px")
                .style("top", (d3.event.pageY - 30) + "px");
        })
        .attr("d", path);

    var mapCodes = {};
    for (var country in subunits.features) {

        var id = subunits.features[country].id;
        var name = subunits.features[country].properties.name;
        mapCodes[id] = name;
    }
    for (var countryCode in totals) {
        if (typeof mapCodes[countryCode] === 'undefined') {
            console.log('Could not find on map: ' + countryCode + " - " + countries[countryCode]);
        }
    }

}
</script>