# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

var map = new OpenLayers.Map('map');

var wms = new OpenLayers.Layer.WMS( "OpenLayers WMS",
    "http://vmap0.tiles.osgeo.org/wms/vmap0", {layers: 'basic'} );
map.addLayer(wms);
map.zoomToMaxExtent();
