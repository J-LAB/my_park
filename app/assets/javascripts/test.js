
window.addEventListener('load', function() {
    /*

    var epsg4326 = new OpenLayers.Projection('EPSG:4326');
    var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    var lon = -75.1667;
    var lat = 39.95;
    var zoom = 15;

    var map = new OpenLayers.Map("map");

    var parkStyle = new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
            fillColor: "#00FF00",
            fillOpacity: 0.1,
            strokeOpacity: 0.2,
            strokeColor: "#00FF00",
            graphicZIndex: 3,
            graphicOpacity: 0.5,
transparent: true
        })
    });

    var trailStyle = new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
            strokeColor: "#000000",
            strokeOpacity: 1,
            graphicZIndex: 2,
            graphicOpacity:1 
        })
    });
    var layer = new OpenLayers.Layer.WMS( "OpenLayers WMS", 
            "http://vmap0.tiles.osgeo.org/wms/vmap0",
            {layers: 'basic'} );

    var parks_layer = new OpenLayers.Layer.Vector("Parks", {
transparent: true,
        opacity: 0.1,
        isBaseLayer       : false,
        strategies: [new OpenLayers.Strategy.Fixed()],
        protocol: new OpenLayers.Protocol.HTTP({
            url: "assets/PPR_Boundaries.geojson",
            format: new OpenLayers.Format.GeoJSON()
        }),
        styleMap: parkStyle
    });

    var trails_layer  = new OpenLayers.Layer.Vector("Trails", {
        opacity: 0.5,
        isBaseLayer       : false,
        strategies: [new OpenLayers.Strategy.Fixed()],
        protocol: new OpenLayers.Protocol.HTTP({
            url: "assets/trails.geojson",
            format: new OpenLayers.Format.GeoJSON()
        }),
    });

var mapLayer = new OpenLayers.Layer.OSM();
var google = new OpenLayers.Layer.Google("google");



    map.addLayers([google, parks_layer, trails_layer]);
//mapLayer.setVisibility(false);
    //map.addLayer(layer);
    map.setCenter(new OpenLayers.LonLat(lon, lat), zoom);
    */

    var map = new OpenLayers.Map('map', {
        projection: 'EPSG:3857',
        layers: [
            new OpenLayers.Layer.Google(
                "Google Physical",
                {type: google.maps.MapTypeId.TERRAIN}
            ),
            new OpenLayers.Layer.Google(
                "Google Streets", // the default
                {numZoomLevels: 20}
            ),
            new OpenLayers.Layer.Google(
                "Google Hybrid",
                {type: google.maps.MapTypeId.HYBRID, numZoomLevels: 20}
            ),
            new OpenLayers.Layer.Google(
                "Google Satellite",
                {type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22}
            )
        ],
        center: new OpenLayers.LonLat(-75.1667, 39.95)
            // Google.v3 uses web mercator as projection, so we have to
            // transform our coordinates
            .transform('EPSG:4326', 'EPSG:3857'),
        zoom: 10 
    });
    map.addControl(new OpenLayers.Control.LayerSwitcher());
    
    // add behavior to html
    var animate = document.getElementById("animate");
    animate.onclick = function() {
        for (var i=map.layers.length-1; i>=0; --i) {
            map.layers[i].animationEnabled = this.checked;
        }
    };
}, false);
