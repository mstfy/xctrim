# xctrim

A cli program written in swift (with async/await) that removes the unnecessary parts of xcframeworks.

## Usecase
Say you downloaded firebase sdk and added it to your project. It is a huge sdk that has many xcframeworks. And every xcframework has ios, ios simulator, tvos, tvos simulator, mac and catalyst slices. Usually your project doesn't need all these slices. For example if your app is only ios app then you just need ios and ios simulator slices. With xctrim you can keep only necessary parts and reduce the space.

## Installation
Clone the repo and run `swift build -c release` command. You will find xctrim executable in `.build/release` directory

## Usage
`xctrim --path directory/that/contains/xcframeworks --platform "ios arm64" --platform "iossimulator arm64 x86_64"`
This command will keep only ios version with arm64 slice and ios simulator version with arm64(apple silicon) and 64 bit intel slices and remove every other version and slice from xcframeworks. If you omit the path parameter it finds xcframeworks in current path.

### Available platforms and slices
|  Platform        |  Slices                    |
|------------------|----------------------------|
|  ios             |  arm64, armv7              |
|  iossimulator    |  arm64, i386, x86\_64      |
|  ioscatalyst     |  arm64, x86\_64            |
|  tvos            |  arm64                     |
|  tvossimulator   |  arm64, x86\_64            |
|  macos           |  arm64, i386, x86\_64      |
