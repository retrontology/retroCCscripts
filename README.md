# retroCCscripts
Retrontology's collection of Computer Craft scripts (lua based programming mod for Minecraft)

---
## audio
### Description
Plays a CC encoded audio file via a speaker attached to the computer.

### Usage
```
audio <file> <volume>
```
---
## break_floor
### Description
Program for a turtle that makes it travel in a two dimensional plane XZ defined by \<length\> and \<width\> and breaks the floor beneath it.

### Usage
```
break_floor <length> <width>
```
---
## build_floor
### Description
Program for a turtle that makes it travel in a two dimensional plane XZ defined by \<length\> and \<width\> and replaces the floor beneath it with blocks defined by \<item\>.

### Usage
```
build_floor <item> <length> <width>
```
---
## build_walls
### Description
Program for a turtle that builds four vertical walls in a rectangle defined by \<length\> \<width\> \<height\> using blocks defined by \<item\>

### Usage
```
build_walls <item> <length> <width> <height>
```
---
## clear_land
### Description
Program for a turtle that clears an rectangular prism of land defined by \<length\> and \<width\>. It starts from Y level it's placed at and continues until it does not detect a block above it.

### Usage
```
clear_land <length> <width>
```
---
## dlretro
### Description
Very basic "package manager" that I use to update the scripts on a computer/turtle

### Usage
```
dlretro
```
---
## drop_cobble
### Description
A subroutine that runs in the background designed to find "junk" blocks in the inventory of a turtle and drop them

---
## farm
### Description
A program for a turtle that travels on an XZ plane defined by \<length\> and \<width\> and breaks fully grown wheat below it while planting wheat seeds on empty blocks.

### Usage
```
farm <length> <width>
```
---
## index
### Description
Index of packages to be downloaded by `dlretro`

---
## lava_mine
### Description
A program for a turtle that travels above lava with a water bucket, turning the lava into obsidian, and mining it

### Usage
```
lava_mine
```
---
## main_tunnel
### Description
A program for a turtle that mines out a rectangular prism defined by \<length\>, [width], and [height]. \<length\> is required while [width] and [height] are optional and default to 4.

### Usage
```
main_tunnel [length] <width> <height>
```
---
## mine_stairs
### Description
Incomplete program to make stairs descending into a mine

---
## mine
### Description
A program for a turtle to mine in a 1x2 tunnel defined by [length]*8. If torches are in the inventory it will place them appropriately to prevent mob spawning. It will drop "junk" blocks from it's inventory in an attempt to only retain "valuable" blocks. The filter is defined by [ore/debris]

### Usage
```
mine [ore/debris] [length]
```
---
## ocean_monument
### Description
Collection of scripts for turtles to assist in building an ocean monument farm. Utilizes GPS.

**fill**
Fills the ocean monument with sand to eliminate water

**clear**
Clears out the sand from the `fill` command

**shell**
Builds a shell defined by <item> around the guardian farm

---
## play_gif
### Description
Plays a gif using the `GIF` library

### Usage
```
play_gif <file>
```
---
## quarry
### Description
Program for a turtle that mines out a rectangular prism defined by <length>, <width>, and <height> starting from the Y level it's placed on and goes downwards.

### Usage
```
quarry <length> <width> <height>
```
---
## refuel
### Description
Program for a turtle with an empty bucket in it's inventory to refuel using lava <amount> of times. The direction is specified by [dir] using either `up` or `down`, if not specified it will pull in lava from the front.

### Usage
```
refuel <amount> [dir]
```
---
## retrostd
### Description
Library to be used by any ComputerCraft computer

---
## retroturtle
### Description
Libary to be used only by turtles