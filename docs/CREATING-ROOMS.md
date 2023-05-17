# Creating rooms used in level generation

## Example rooms

First off, you have examples Rooms in `scenes/rooms/*.tcsn`. 

They represent each combinaison possible of doors agancement. 

Rooms can have 1 door on the right-side, left-side, top and bottom, with any combination of the 4, minus the combinaision where there is no doors.

<details>
  <summary>Maths lol</summary>
  4 positions with 2 possibilities (exist/doesn't exist) minus 1 possibility
  
  `2^4 - 1 == 15`
  
</details>

So 15 possible combinaisons, thus 15 example rooms.

## Some rooms lack walls ? 

### Explanation

As you will see, some rooms doesn't have their top walls and right walls. Let's explain this with one example: 

`[A][B]`

We have RoomA and RoomB next to each other, so RoomA has a right door, and RoomB has a left door. But technically they are exactly the same door, and wall! So to avoid having some walls overlaping each other, we can just choose to only instantiate the left wall/door of RoomA or the right wall/door of RoomB, it would be exactly the same result!

It is the same with top/bottoms doors/walls, we chose in this project to only instantiate left walls and bottom walls when they share it with another room (so when there is a door).

## lol just tell me how to do it

Basically, when you always "draw" a left wall, (with or without door), same for bottom wall. And you only draw right and top wall when there is no door (it applies for the far right collumn of ground and far top row of ground).

## Last thing to do for the doors

As you can see on the test rooms, there is a node called "Doors" with some names, which represents the doors. It's very important for level generation. If you have a room with the 4 doors, it will be like so:

![image](https://github.com/gabriel654165/Very-Good-Cop/assets/58398928/9ec0b2bc-9df5-488e-b030-93ee1ef66148)



## Drawing part

We have two tilemaps that separates walls from the rest:

- "Walls" tilemap where you put all the walls (duh)
- "Ground" tilemap where you put the ground and other cool stuff.

### Other cool stuff ? 

You can choose multiple layer of collision on the same tilemap, so you can put the ground with no collision and other stuff like furnitures with another layer of collision.


## Spawnables ! (Enemies/Patrols and power-ups)

In your hierarchy you have the "TopNode" (called TestRoom in example rooms). The "Room" script should be attached to this node

As a children you need a Node2D called "RoomConfig". As a children of this node you should have a Node2D "Patrols" node and a Node2D "PowerUpPoints" node.

- `Patrols`
    - Put a Node2D that represents a patrol, call it however you like
    - As a children of this new Node2D, put (in order) some Node2Ds that will represent the patrol path
    - Make as many as you want, a random number of patrols you put in your room will be chosen depending on the difficulty the player is at the moment of playing.
- `PowerUpPoints`
    - Every place you want a power up to be randomly spawned, put a Node2D as a child of this node


Example:

This room has 2 patrols of 4 point each and 1 point where a power up can be spawnedJe regarde tout ça cette aprem
NOUVEAU
￼
gabi_mdk — Aujourd’hui à 15:04
Yep hésite pas si t'as des questions bg
￼
Envoyer un message dans #general


![image](https://github.com/gabriel654165/Very-Good-Cop/assets/58398928/daf63012-6e6e-4faf-b6b5-d40049cd6106)



## Enemy specific stuff (mandatory)

Yeaaaah so now you have to do the enemies stuff so they can move around in your room and all this shit.

Create a 2DNavigationArea, it should cover the whole walkable space, door space included, where it should really sticks to the end of the door, check some already made rooms to understand what I mean.

It's very important cause each 2DNavigationArea should touch each other between each rooms so it can be considered as the same big NavigationArea

If you put furnitures or collidable stuff, make your Area go around it.
