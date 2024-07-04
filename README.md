# stubby-wrench

## Introduction

This is a 3D-printable [OpenSCAD](https://openscad.org/) model of standard quarter-inch
hex-bit holders. It was created as part of an experiment with texture and the [Round-Anything
library](https://github.com/Irev-Dev/Round-Anything).

![Image of Stubby Wrench](../media/media/stubby-wrench.jpg?raw=true "Stubby Wrench with Bit")

## Model

There are two models:

<div class="model" data-name="Stubby Wrench" data-icon-size="128" data-left-icon="stubby-wrench.icon.png" data-left="stubby-wrench.stl"><!-- expanded by annotate-model --><table align="center" width="100%"><tbody><tr width="100%"><td align="center" width="160" height="160"><a href="../media/media/stubby-wrench.stl" target="_blank" title="View Stubby Wrench Model"><img src="../media/media/stubby-wrench.icon.png" alt="Stubby Wrench Model" width="128" height="128" /></a></td><td>

### Stubby Wrench

A textured T-style handle for a hex bit. Many dimensions can be modified
and adjusted by working with source and the OpenSCAD customizer.

</td></tr></tbody></table></div>

<div class="model" data-name="Stubby Bit Holder" data-icon-size="128" data-left-icon="stubby-bit-holder.icon.png" data-left="stubby-bit-holder.stl"><!-- expanded by annotate-model --><table align="center" width="100%"><tbody><tr width="100%"><td align="center" width="160" height="160"><a href="../media/media/stubby-bit-holder.stl" target="_blank" title="View Stubby Wrench Model"><img src="../media/media/stubby-bit-holder.icon.png" alt="Stubby Wrench Model" width="128" height="128" /></a></td><td>

### Stubby Bit Holder

The stubby bit holder is intended with a small bit. Compared to the
stubby wrench, the depth of the receiver is shorter (10mm vs 13mm) and
the model is taller. This allows more space for your fingers between the
bit and the handle.

</td></tr></tbody></table></div>

## Printing

I use a Creality Ender 3 Pro to build from PLA with a layer height of
0.20mm. There are no particular restrictions on printing, but you might
want to optimize where your slicer puts seams (e.g. "Rear" is a good
selection).

## Source

The bit holders are built using OpenSCAD. *stubby-wrench.scad* is the main
file for all the models.
