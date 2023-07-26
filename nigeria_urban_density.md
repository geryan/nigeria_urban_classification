# Urban density classification for Nigeria
Gerry Ryan
2023-07-26

This is a preliminary classification of urban density based on volume of
built structures in an area for Nigeria.

The basis for these classifications is the [GHS built-up volume
grid](https://ghsl.jrc.ec.europa.eu/ghs_buV2023.php) produced by the
European Commission Joint Research Council, which measures the bult
volume in cubic metres over space.

Here is the base layer for all of Nigeria:

![](nigeria_urban_density_files/figure-commonmark/unnamed-chunk-2-1.png)

And focussed in on the south-west of the country around Lagos:

![](nigeria_urban_density_files/figure-commonmark/unnamed-chunk-3-1.png)

Using Jenks natural breaks classification of the cubed root of
volume[^1] we classify these into either three density classes:

![](nigeria_urban_density_files/figure-commonmark/unnamed-chunk-4-1.png)

Or six density classes:

![](nigeria_urban_density_files/figure-commonmark/unnamed-chunk-5-1.png)

This is the same data as above focussing on the Lagos area for 3
classes:

![](nigeria_urban_density_files/figure-commonmark/unnamed-chunk-6-1.png)

And six classes:

![](nigeria_urban_density_files/figure-commonmark/unnamed-chunk-7-1.png)

[^1]: This is done to ‘flatten’ the volumes to allowing for greater
    differentiation among the lower end of the scale, and relatively
    less differentiation at the upper end, e.g. among very tall
    buildings
