# stubby-wrench

## Introduction

These are 3D-printable [OpenSCAD](https://openscad.org/) models of
standard quarter-inch hex-bit holders. They were created as part of an
experiment with texture and the
[Round-Anything](https://github.com/Irev-Dev/Round-Anything) library.

![Image of Stubby Wrench and Bit Holder](../media/media/stubby-double.jpg?raw=true "Stubby Wrench and Stubby Bit Holder")

## Model

There are two models:

<div class="model" data-name="Stubby Wrench" data-icon-size="128" data-left-icon="stubby-wrench.icon.png" data-left="stubby-wrench.stl" data-right="stubby-wrench.installed.jpg"><!-- expanded by annotate-model --><table align="center" width="100%"><tbody><tr width="100%"><td align="center" width="160" height="160"><a href="../media/media/stubby-wrench.stl" target="_blank" title="View Stubby Wrench Model"><img src="../media/media/stubby-wrench.icon.png" alt="Stubby Wrench Model" width="128" height="128" /></a></td><td>

### Stubby Wrench

A textured T-style handle that receivers a hex bit. Many dimensions can be modified
and adjusted by working with source and the OpenSCAD customizer.

</td><td align="center" width="160" height="160"><a href="../media/media/stubby-wrench.installed.jpg" target="_blank" title="View Stubby Wrench Installed"><img src="../media/media/stubby-wrench.installed.jpg" alt="Stubby Wrench Installed" width="128" height="128" /></a></td></tr></tbody></table></div>

<div class="model" data-name="Stubby Bit Holder" data-icon-size="128" data-left-icon="stubby-bit-holder.icon.png" data-left="stubby-bit-holder.stl" data-right="stubby-bit-holder.installed.jpg"><!-- expanded by annotate-model --><table align="center" width="100%"><tbody><tr width="100%"><td align="center" width="160" height="160"><a href="../media/media/stubby-bit-holder.stl" target="_blank" title="View Stubby Bit Holder Model"><img src="../media/media/stubby-bit-holder.icon.png" alt="Stubby Bit Holder Model" width="128" height="128" /></a></td><td>

### Stubby Bit Holder

The stubby bit holder is intended for a small bit. Compared to the
stubby wrench, the depth of the receiver hole is shorter (10 mm vs. 13 mm) and
the model is taller. This allows more space for your fingers between the
bit and the handle.

</td><td align="center" width="160" height="160"><a href="../media/media/stubby-bit-holder.installed.jpg" target="_blank" title="View Stubby Bit Holder Installed"><img src="../media/media/stubby-bit-holder.installed.jpg" alt="Stubby Bit Holder Installed" width="128" height="128" /></a></td></tr></tbody></table></div>

## Printing

I use a Creality Ender 3 Pro to build from PLA with a layer height of
0.20mm. There are no particular restrictions on printing, but you might
want to optimize your slicer's seam placement (e.g. "Rear" is a good
selection).

## Source

The bit holders are built using OpenSCAD. *stubby-wrench.scad* is the main
file for all the models.

### Libraries

You'll need the [Round-Anything](https://github.com/Irev-Dev/Round-Anything)
OpenSCAD library as well as the semi-standard MCAD library:

- [MCAD](https://github.com/openscad/MCAD)
- [Round-Anything](https://github.com/Irev-Dev/Round-Anything)

Install these libraries below your OpenSCAD [library folder](https://wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries)
and then that folder should include the following directories:

```
    libraries
    ├── MCAD/
    └── Round-Anything/
```

Alternatively, if you're building on Linux, `make local-libraries`
should fetch all the files and place them in the local directory
"./libraries". Then, you can set the environment variable
[OPENSCADPATH](https://wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries#Setting_OPENSCADPATH)
to include that directory in OpenSCAD's library search path.
