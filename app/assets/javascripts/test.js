
window.addEventListener('load', function() {

    var map = new OpenLayers.Map( 'map' );
    var layer = new OpenLayers.Layer.WMS( "OpenLayers WMS", 
            "http://vmap0.tiles.osgeo.org/wms/vmap0",
            {layers: 'basic'} );
    var geojson_layer = new OpenLayers.Layer.Vector("Trails", {
        isBaseLayer       : true,
        strategies: [new OpenLayers.Strategy.Fixed()],
        protocol: new OpenLayers.Protocol.HTTP({
            url: "assets/trails.geojson",
            format: new OpenLayers.Format.GeoJSON()
        })
    });
    map.addLayer(geojson_layer);
    map.setCenter(new OpenLayers.LonLat(-75.1667, 39.9500), 15);
}, false);
