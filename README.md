# react-native-pixel-color

Get the color of a pixel from a base64 PNG image

## Compatibility

Only works on Android at the moment, iOS version coming shortly.

## Installation


```sh
npm install react-native-pixel-color
```


## Usage


```js

const base64 = 'iVBORw0KGgoAAAANSUhEUg...MxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=';
const x = 10
const y = 10

const color = await getPixelColor(base64, x, y)
console.log(color)
// { "alpha": 255, "blue": 77, "green": 204, "red": 255 }
```


## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
