<img src="https://i.imgur.com/nVmUzsy.png" width="64" height="64"> GloInstaBugReporter: Instantly report UI bugs.
======================================

[![Version](https://img.shields.io/badge/version-0.0.1-blue.svg)](https://pub.dartlang.org/packages/fluro)

## Features
- Capture screenshot
- Add description and title for created task
- Editing screenshot

## Version compatibility

See CHANGELOG for all breaking (and non-breaking) changes.

## Getting started

You should ensure that you add the router as a dependency in your flutter project.
```yaml
dependencies:
 glo_insta_bug_reporter: "^0.0.1"
```

You can also reference the git repo directly if you want:
```yaml
dependencies:
 fluro:
   git: git://github.com/BohdanNikoletti/GloInstaBugReporter
```

You should then run `flutter packages upgrade` or update your packages in IntelliJ.

## Example Project

There is a pretty sweet example project in the `example` folder. Check it out. Otherwise, keep reading to get up and running.

## Usage Example
Pick a board and column      |  Fill ticket important fields  |  Edit captured screenshot
:---------------------------:|:------------------------------:|:-------------------------:
<img src="https://i.imgur.com/SvKQAaE.png" /> | <img src="https://i.imgur.com/bPBj6Zp.png" /> | <img src="https://i.imgur.com/AblvIhC.png" />
#### For get access to plugin features:
 - Create your OAuth app folowing instructions on [GitKraken web site](https://support.gitkraken.com/developers/oauth/);
 - Add file named glo_config.json [file structure example](#file-structure-example) into assets directory in project with config that containes generated identifier & secret from previous step;
 - Extend your state from GloReportableWidgetState. 

##### File structure example

```json
{
  "identifier": "YOUR_IDENTIFIER",
  "secret": "YOUR_SECRET"
}
```
##### main.dart
```dart
class _MyHomePageState extends GloReportableWidgetState<HomePage> {
  @override
  Widget buildRootWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Test screenShot maker',
            ),
            Text(
              'tap',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Credits

GloInstaBugReporter is owned and maintained by [Bohdan Mihiliev](https://github.com/BohdanNikoletti)

## License

GloInstaBugReporter is available under the MIT license. See the [LICENSE](https://github.com/BohdanNikoletti/GloInstaBugReporter/blob/develop/LICENSE) file for more info.

