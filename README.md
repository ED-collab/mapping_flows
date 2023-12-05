# mapping_flows
Mapping flows across a landscape with GIS coordinates in R

These scripts are for generating a map using pre-existing shapefiles and populating it with arrows representing flow between geographic coordinates.

The idea is to provide generalizable code for mapping flows (in this case of seeds). This aims to support visualization of work on seed flow mapping and the movement of both plant germplasm and seed-vectored disease.

The required files for input are an excel/csv sheet that includes origins (ox,oy) and destinations (dx, dy), and shapefiles of the area in question (or you can use crude built-in ones from another R package like 'maps').

The flowmap_trips_segments.R file provides a simple way to draw curved arrows from origins to destinations (without building an igraph object). This is most appropriate when illustrating outgoing or incoming networks from a small number of individuals.

I will continue updating these scripts (eg. the edgebundling example is not currently working).
