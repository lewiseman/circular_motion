<center><h1>Circular Motion</h1></center>

<p align="center">
  <img alt="easy dashboard", src="https://raw.githubusercontent.com/lewiseman/assets/master/circular_motion_banner.png">
</p>

This package provides a way to create widgets in a circular position and able to scroll and make them rotate.

|Any Shape|Any Position|Customizable|
|:------------:|:------------:|:-------------:|
| [![](https://raw.githubusercontent.com/lewiseman/assets/master/circular_motion_1.png)]() |	[![](https://raw.githubusercontent.com/lewiseman/assets/master/circular_motion_2.png)]()  | [![](https://raw.githubusercontent.com/lewiseman/assets/master/circular_motion_3.png)]() |

|	|		|		|
|:------------:|:------------:|:-------------:|
| [![](https://raw.githubusercontent.com/lewiseman/assets/master/circular_motion_vd_1.gif)]() |	[![](https://raw.githubusercontent.com/lewiseman/assets/master/circular_motion_vd_2.gif)]()  | [![](https://raw.githubusercontent.com/lewiseman/assets/master/circular_motion_vd_3.gif)]() |

<br>
The shape of cirlcle will be dependent on the parent widget.
<br>
<br>

## Usage
API

The `centerWidget` is the widget that will be in the center of the circular motion.
```dart
centerWidget: Text('Center'),
```
<br>
You can create the circular motion in the following ways:

### CircularMotion
Example:

```dart
CircularMotion(
    centerWidget: Text('Center'),
    children: [
     Text('0'),
     Text('1'),
     Text('2'),
     Text('3'),
  ],
)
```

### CircularMotion.builder()
Example

```dart
CircularMotion.builder(
    itemCount: 18,
    centerWidget: Text('Center'),
    builder: (context, index) {
      return Text('$index');
    }
)
```

## Issues and Feedback
Please feel free to report any issues you face<br>
Also PR's and additional feedback is appreciated

> Enjoy 💫