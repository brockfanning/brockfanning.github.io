---
title: How much money is the US giving other countries?
tags: [datavis]
---
Here is a statistic I have been curious about: how much money does the US give to other countries? This was a good chance to stretch my R and D3 chops.

I was only able to find machine-readable (well, if you can call a table in a PDF "machine-readable") data for a few recent years. The radio buttons below control which year is being visualized.

<style>
.country {
    touch-action: manipulation;
    -ms-touch-action: manipulation;
}
#controls {
    display: none;
    position: fixed;
    bottom: 0px;
    left: 0px;
    text-align: center;
    background: lightgoldenrodyellow;
    width: 80%;
    padding: 10px 10%;
    box-shadow: 0 -5px 5px rgba(0, 0, 0, .5);
    font-size: 3em;
}
#tooltip {
    background: white;
    position: absolute;
    pointer-events: none;
    padding: 5px;
    border-radius: 5px;
    filter: drop-shadow(rgba(0, 0, 0, 0.3) 0 2px 10px);
}
#tooltip:after {
    border: 10px solid;
    border-color: white transparent transparent;
    content: "";
    left: 0px;
    position: absolute;
    top: 95%;
}
</style>
<div id="controls">
    <input name="year" type="radio" value="2013 actual" id="year-2013" checked>
    <label for="year-2013">2013</label>
    <input name="year" type="radio" value="2014 actual" id="year-2014">
    <label for="year-2014">2014</label>
    <input name="year" type="radio" value="2015 actual" id="year-2015">
    <label for="year-2015">2015</label>
</div>

First I went for the obvious visualization, a world map:
<div id="map"></div><br />

But to better see the rankings between countries, here is a simple bar chart:
<div id="bars"></div><br />
(In the bar graph above, countries getting less than $20m are not shown, to keep the bars from getting too thin.)

<!--

The obvious question for any particular country and amount of funding: Why? Why do we give Country X 200 times more than Country Y? The answer to that question, of course, is probably unique and nuanced for each country. But, since we have the power of data visualization at our disposal, let's just see if there might be any correlations to known statistics.

For each of the metrics below, I am asking these questions:

1. For each country the US gives money to, what is the ratio between funding given, and the [insert metric here]?
2. What is the average of these ratios across all countries?
3. For each country the US gives money to, how does the ratio from question #1 deviate from the ratio (average) from question #2? And, in which direction?

Funding vs GDP (gross domestic product)

Funding vs area

Funding vs population

Funding vs population density

-->

### Dev notes

A few notes about the development steps, so I can refer to this later:

* Install rJava and Tabulizer: https://github.com/ropenscilabs/tabulizer
* Run R code to generate us-foreign-aid.json file
* Install ogr2ogr and topojson
* Get geo data and create map json
    * [Download and unzip geo data](http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_map_units.zip)
    * Run ogr2ogr on the .shp file: `ogr2ogr -f "GeoJSON" subunits.json ne_50m_admin_0_map_units.shp`
    * Run topojson on that file: `topojson -o world-countries.json --id-property iso_a3 --properties name=name -- subunits.json`
* Write d3 code

### Source code

* [R code](https://github.com/brockfanning/brockfanning.github.io/blob/master/r/us-foreign-aid.r)
* [d3 code](https://github.com/brockfanning/brockfanning.github.io/blob/master/_posts/2016-10-12-how-much-is-the-us-giving-other-countries.md)

### Source of data

* 2013 actual: pages 15-21 of [this pdf](http://www.state.gov/documents/organization/224071.pdf)
* 2014 actual: pages 14-19 of [this pdf](http://www.state.gov/documents/organization/238223.pdf)
* 2015 actual: pages 14-18 of [this pdf](http://www.state.gov/documents/organization/252735.pdf)
* 2016 request: pages 20-25 of [this pdf](http://www.state.gov/documents/organization/238223.pdf)
* 2017 request: pages 19-24 of [this pdf](http://www.state.gov/documents/organization/252735.pdf)

<script src="https://d3js.org/d3.v4.min.js"></script>
<script src="https://d3js.org/topojson.v1.min.js"></script>
<script src="https://d3js.org/d3-queue.v3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/numeral.js/1.5.3/numeral.min.js"></script>
<style>
#map svg {
    background: lightblue;
}
#map {
    margin: 0 auto;
    max-width: 90%;
    overflow: hidden;
}
#map svg path {
    vector-effect: non-scaling-stroke;
}
</style>
<script>
// The world map visualization.
var width = 740,
    height = 475;

var svg = d3.select("#map").append("svg")
    .attr("width", width)
    .attr("height", height);

var g = svg.append("g");

var tooltip = d3.select("body").append("div")
    .attr('id', 'tooltip')
    .style("opacity", 0);

var projection = d3.geoMercator()
    .scale(140)
    .translate([width / 2, height / 2]);
var path = d3.geoPath().projection(projection);

var zoom = d3.zoom()
    .scaleExtent([1, 8])
    .on("zoom", zoomed);
svg.call(zoom);

// Now set up the bar graph.
var bHeight = 400;
var bWidth = 740;
var barWidth = 50;
var barOffset = 5;

var bsvg = d3.select('#bars').append('svg')
    .attr('width', bWidth)
    .attr('height', bHeight)
    .style('background', '#C9D7D6');

// Hold some one-time data out here.
var world, aid, countries, countriesAlphabetic, highValue = 0, colorScale;

// Keep track of which year is being displayed.
var currentYear = "2013 actual";

// Behavior for the year switcher.
d3.selectAll("#controls input[name=year]").on("change", function() {
    currentYear = this.value;
    updateMap();
    updateBarGraph();
});

// Since we have to load 2 separate json files, use d3.queue.
d3.queue()
    .defer(d3.json, "/data/geo/world-countries.json")
    .defer(d3.json, "/data/us-foreign-aid.json")
    .await(analyze);

// This function is executed one time after all the data is loaded.
function analyze(error, loadedWorld, loadedAid) {
    world = loadedWorld;
    aid = loadedAid;

    // Fix some countries that don't get ids for some reason.
    var brokenCountries = {
        "Fed. of Bos. & Herz.": "BIH",
        "Gaza": "PSE",
        "Georgia": "GEO",
        "Papua New Guinea": "PNG",
        "Portugal": "PRT",
        "Serbia": "SRB",
        "West Bank": "PSE"
    }
    for (var index in world.objects.subunits.geometries) {
        if ("-99" == world.objects.subunits.geometries[index].id) {
            var name = world.objects.subunits.geometries[index].properties.name;
            world.objects.subunits.geometries[index].id = brokenCountries[name];
        }
    }

    // Convert the geo data.
    subunits = topojson.feature(world, world.objects.subunits);

    // Temporary keyed version of our aid data.
    var tempData = {};
    for (var year in aid) {
        for (var country in aid[year]) {
            var countryCode = aid[year][country].code;
            var countryTotal = aid[year][country].total;
            // Start off with all zeroes.
            if (typeof tempData[countryCode] === 'undefined') {
                tempData[countryCode] = {};
                for (var year2 in aid) {
                    tempData[countryCode][year2] = 0;
                }
            }
            tempData[countryCode][year] = countryTotal;
        }
    }

    // Make a list of data combining actual countries with our data. First, get
    // all countries from the world map and store their names.
    countries = [];
    for (var country in subunits.features) {
        var country = subunits.features[country];
        if (typeof tempData[country.id] !== 'undefined') {
            country.years = tempData[country.id];
        }
        else {
            country.years = {};
            for (var year in aid) {
                country.years[year] = 0;
            }
        }
        countries.push(country);
    }

    // For the bar graph, we'll want to alphabetize the countries.
    countries = countries.sort(function(a, b) {
        if (a.properties.name < b.properties.name) {
            return -1;
        }
        if (a.properties.name > b.properties.name) {
            return 1;
        }
        return 0;
    });

    // We also need the highest value across all years and all the countries,
    // to properly scale colors and other attributes.
    for (var country in countries) {
        for (var year in countries[country].years) {
            var thisValue = countries[country].years[year];
            if (thisValue > highValue) {
                highValue = thisValue;
            }
        }
    }

    colorScale = d3.scaleLinear()
        .domain([0, highValue])
        .range(['#FFFFFF', 'darkgreen']);

    // Do the static parts of the map.
    g.selectAll(".country")
        .data(countries)
        .enter().append("path")
        .on('click', tooltipClick)
        .attr("d", path)
        .classed("country", true)
        .style("stroke", "#000000")
        .style("fill", "#FFFFFF");

    // Draw the countries on the bar graph is dimensionless white bars.
    bsvg.selectAll('.country')
        .data(countries)
        .enter()
        .append('rect')
        .classed('country', true)
        .style('fill', '#FFFFFF')
        .attr('width', 0)
        .attr('height', 0)
        .on('click', tooltipClick);

    // Now the dynamic stuff.
    updateMap();
    updateBarGraph();
}

// This redraws the already-initialized map based on the current year.
function updateMap() {

    g.selectAll(".country")
        .transition().style("fill", function(d) {
            if (d.years[currentYear] == 0) {
                return '#CCCCCC';
            }
            return colorScale(d.years[currentYear]);
        });
}

// This redraws the already-initialized bar graph based on the current year.
function updateBarGraph() {

    // Tweak this threshold to make the bar graph manageable. We don't want to
    // show EVERY country, because it makes the bars too skinny.
    var threshold = 20000;

    // Query the countries that clear that threshold.
    var worthShowing = bsvg.selectAll('.country').filter(function(d) {
        return (d.years[currentYear] >= threshold);
    });

    // D3 scales.
    var barScaleX = d3.scaleBand()
        .domain(d3.range(0, worthShowing.size()))
        .range([0, bWidth]);
    var barScaleY = d3.scaleLinear()
        .domain([0, highValue])
        .range([0, bHeight]);

    // Update the dimensions/locations of the bars.
    worthShowing.transition()
        .style('fill', function (d) {
            return colorScale(d.years[currentYear]);
        })
        .attr('width', barScaleX.bandwidth())
        .attr('height', function(d) {
            return barScaleY(d.years[currentYear]);
        })
        .attr('x', function (d, i) {
            return barScaleX(i);
        })
        .attr('y', function (d) {
            return bHeight - barScaleY(d.years[currentYear]);
        });
}

// Callback for zooming the map.
function zoomed() {
    var transform = "translate(" + d3.event.transform.x + "," + d3.event.transform.y + ") scale(" + d3.event.transform.k + ")";
    g.attr("transform", transform);
};

// Callback for clicking a country or bar.
function tooltipClick(d) {
    var total = numeral(d.years[currentYear] * 1000).format("($0[.]00a)");
    tooltip.style("opacity", 0);
    tooltip.html(d.properties.name + ": " + total);
    tooltip.style("left", (d3.event.pageX - 10) + "px");
    tooltip.style("top", (d3.event.pageY - 50) + "px");
    tooltip.transition().style("opacity", 1);
}
</script>